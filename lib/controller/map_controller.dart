// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'package:final_project_admin_website/model/customer_model.dart';
import 'package:final_project_admin_website/model/shipment_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminMapController extends GetxController {
  // --- STATE VARIABLES ---
  GoogleMapController? mapController;
  final markers = <Marker>{}.obs;
  final isLoading = true.obs;
  final Rx<ShipmentModel?> selectedShipment = Rx<ShipmentModel?>(null);
  final Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);

  // --- NEW: Holds the list of items when a stacked marker is tapped ---
  final RxList<ShipmentModel> clusteredSelection = <ShipmentModel>[].obs;

  // --- DATA & CONFIGURATION ---
  List<ShipmentModel> _allShipments = [];
  List<CustomerModel> _allCustomers = [];
  final Map<ShipmentStatus, BitmapDescriptor> _statusIcons = {};
  final List<ShipmentStatus> _displayableStatuses = const [
    ShipmentStatus.inTransit,
    ShipmentStatus.delivered,
    ShipmentStatus.enteredPort,
    ShipmentStatus.unLoaded,
    ShipmentStatus.waitingPickup,
  ];

  // --- FIREBASE REFS ---
  final DatabaseReference _positionsRef =
      FirebaseDatabase.instance.ref('ship_positions');
  final DatabaseReference _shipmentsRef =
      FirebaseDatabase.instance.ref('shipments');
  final DatabaseReference _customersRef =
      FirebaseDatabase.instance.ref('customers');

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    isLoading.value = true;
    await _loadMarkerIcons();
    await _fetchAllData();
    _listenToShipPositions();
    isLoading.value = false;
  }

  Future<void> _loadMarkerIcons() async {
    _statusIcons[ShipmentStatus.inTransit] =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    _statusIcons[ShipmentStatus.enteredPort] =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    _statusIcons[ShipmentStatus.unLoaded] =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    _statusIcons[ShipmentStatus.waitingPickup] =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    _statusIcons[ShipmentStatus.delivered] =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  }

  Future<void> _fetchAllData() async {
    final shipmentSnapshot = await _shipmentsRef.get();
    if (shipmentSnapshot.exists) {
      final data = shipmentSnapshot.value as Map<dynamic, dynamic>;
      _allShipments = data.values
          .map((e) => ShipmentModel.fromFirebase(Map<String, dynamic>.from(e)))
          .toList();
    }
    final customerSnapshot = await _customersRef.get();
    if (customerSnapshot.exists) {
      final data = customerSnapshot.value as Map<dynamic, dynamic>;
      _allCustomers = data.values
          .map((e) => CustomerModel.fromFirebase(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  void _listenToShipPositions() {
    _positionsRef.onValue.listen((event) {
      if (event.snapshot.value == null) return;
      final positions = event.snapshot.value as Map<dynamic, dynamic>;
      final newMarkers = <Marker>{};

      final shipmentsToShow = _allShipments
          .where((s) => _displayableStatuses.contains(s.shipmentStatus))
          .toList();

      for (var shipment in shipmentsToShow) {
        if (positions.containsKey(shipment.shipmentId)) {
          final positionData =
              positions[shipment.shipmentId] as Map<dynamic, dynamic>;
          final lat = positionData['latitude'] as double;
          final lng = positionData['longitude'] as double;
          final currentPosition = LatLng(lat, lng);

          newMarkers.add(
            Marker(
              markerId: MarkerId(shipment.shipmentId),
              position: currentPosition,
              icon: _statusIcons[shipment.shipmentStatus] ??
                  BitmapDescriptor.defaultMarker,
              onTap: () {
                // --- CLUSTER DETECTION LOGIC ---
                final itemsAtLocation = _allShipments.where((s) {
                  if (positions.containsKey(s.shipmentId) &&
                      _displayableStatuses.contains(s.shipmentStatus)) {
                    final sPos =
                        positions[s.shipmentId] as Map<dynamic, dynamic>;
                    return LatLng(sPos['latitude'], sPos['longitude']) ==
                        currentPosition;
                  }
                  return false;
                }).toList();

                if (itemsAtLocation.length > 1) {
                  // More than 1 shipment: show the cluster list
                  selectedShipment.value = null;
                  clusteredSelection.value = itemsAtLocation;
                } else {
                  // Exactly 1 shipment: select it normally
                  clusteredSelection.clear();
                  selectShipment(shipment.shipmentId);
                }
              },
            ),
          );
        }
      }
      markers.value = newMarkers;
    });
  }

  void selectShipment(String shipmentId) {
    final shipment =
        _allShipments.firstWhereOrNull((s) => s.shipmentId == shipmentId);
    if (shipment != null) {
      // When selecting a single shipment, ensure the cluster list is cleared.
      clusteredSelection.clear();
      selectedShipment.value = shipment;
      selectedCustomer.value =
          _allCustomers.firstWhereOrNull((c) => c.uid == shipment.senderId);

      Marker? marker;
      try {
        marker = markers.firstWhere((m) => m.markerId.value == shipmentId);
      } catch (e) {
        marker = null;
      }
      if (marker != null && mapController != null) {
        mapController!
            .animateCamera(CameraUpdate.newLatLngZoom(marker.position, 14));
      }
    }
  }

  void searchAndSelectShipment(String query) {
    final lowerCaseQuery = query.toLowerCase();
    final shipment = _allShipments.firstWhereOrNull((s) {
      final customer =
          _allCustomers.firstWhereOrNull((c) => c.uid == s.senderId);
      return s.shipmentId.toLowerCase().contains(lowerCaseQuery) ||
          s.orderId.toLowerCase().contains(lowerCaseQuery) ||
          (customer?.companyName.toLowerCase().contains(lowerCaseQuery) ??
              false);
    });

    if (shipment != null) {
      selectShipment(shipment.shipmentId);
    } else {
      Get.snackbar(
          "Not Found", "No shipment found matching your query: '$query'",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // MODIFIED: clearSelection now clears both single and clustered selections
  void clearSelection() {
    selectedShipment.value = null;
    selectedCustomer.value = null;
    clusteredSelection.clear();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}

// Helper extension to make code cleaner
extension FirstWhereExt<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
