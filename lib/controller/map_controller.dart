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
  final RxList<ShipmentModel> clusteredSelection = <ShipmentModel>[].obs;

  // --- REAL-TIME DATA HOLDERS ---
  List<ShipmentModel> _allShipments = [];
  List<CustomerModel> _allCustomers = [];
  Map<String, dynamic> _latestPositions = {};

  // --- CONFIGURATION ---
  final List<ShipmentStatus> _displayableStatuses = const [
    ShipmentStatus.inTransit,
    ShipmentStatus.delivered,
    ShipmentStatus.enteredPort,
    ShipmentStatus.unLoaded,
    ShipmentStatus.waitingPickup,
  ];
  BitmapDescriptor? shipIcon;
  BitmapDescriptor? portIcon;

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
    await _loadCustomIcons();
    // NEW: Set up all listeners from the start.
    _listenToAllData();
    isLoading.value = false;
  }

  Future<void> _loadCustomIcons() async {
    try {
      shipIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)), 'assets/png/ship.png');
      portIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)), 'assets/png/port.png');
    } catch (e) {
      print("--- ERROR LOADING CUSTOM ICONS: $e ---");
      shipIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      portIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }
  }

  // --- REWRITTEN: This now sets up all real-time listeners ---
  void _listenToAllData() {
    // 1. Listen to Shipments
    _shipmentsRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        _allShipments = (event.snapshot.value as Map)
            .values
            .map((e) =>
                ShipmentModel.fromFirebase(Map<String, dynamic>.from(e as Map)))
            .toList();
        // Whenever shipments change, we must rebuild the markers
        _buildMarkersFromState();
      }
    });

    // 2. Listen to Customers
    _customersRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        _allCustomers = (event.snapshot.value as Map)
            .values
            .map((e) =>
                CustomerModel.fromFirebase(Map<String, dynamic>.from(e as Map)))
            .toList();
        // Customer data might affect panels, but doesn't require a full marker rebuild
      }
    });

    // 3. Listen to Positions
    _positionsRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        _latestPositions =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        // Whenever positions change, we must rebuild the markers
        _buildMarkersFromState();
      }
    });
  }

  // This method is now called by any listener that affects the map markers
  void _buildMarkersFromState() {
    final newMarkers = <Marker>{};
    final shipmentsToShow = _allShipments
        .where((s) =>
            _displayableStatuses.contains(s.shipmentStatus) &&
            _latestPositions.containsKey(s.shipmentId))
        .toList();

    var groupedByLocation = <LatLng, List<ShipmentModel>>{};
    for (var shipment in shipmentsToShow) {
      final posData = Map<String, dynamic>.from(
          _latestPositions[shipment.shipmentId] as Map);
      final location = LatLng(posData['latitude'], posData['longitude']);

      if (groupedByLocation[location] == null) groupedByLocation[location] = [];
      groupedByLocation[location]!.add(shipment);
    }

    groupedByLocation.forEach((location, shipmentsAtLocation) {
      bool isCluster = shipmentsAtLocation.length > 1;
      newMarkers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          icon: isCluster
              ? (portIcon ?? BitmapDescriptor.defaultMarker)
              : (shipIcon ?? BitmapDescriptor.defaultMarker),
          onTap: () {
            handleMarkerTap(location);
          },
        ),
      );
    });
    markers.value = newMarkers;
  }

  void handleMarkerTap(LatLng tappedLocation) {
    final itemsAtLocation = _allShipments.where((s) {
      if (_latestPositions.containsKey(s.shipmentId)) {
        final posData =
            Map<String, dynamic>.from(_latestPositions[s.shipmentId] as Map);
        return LatLng(posData['latitude'], posData['longitude']) ==
            tappedLocation;
      }
      return false;
    }).toList();

    if (itemsAtLocation.length > 1) {
      selectedShipment.value = null;
      clusteredSelection.value = itemsAtLocation;
    } else if (itemsAtLocation.isNotEmpty) {
      selectShipment(itemsAtLocation.first.shipmentId);
    }
  }

  void selectShipment(String shipmentId) {
    final shipment =
        _allShipments.firstWhereOrNull((s) => s.shipmentId == shipmentId);
    if (shipment != null) {
      clusteredSelection.clear();
      selectedShipment.value = shipment;
      selectedCustomer.value =
          _allCustomers.firstWhereOrNull((c) => c.uid == shipment.senderId);

      if (_latestPositions.containsKey(shipmentId)) {
        final posData =
            Map<String, dynamic>.from(_latestPositions[shipmentId] as Map);
        final location = LatLng(posData['latitude'], posData['longitude']);
        if (mapController != null) {
          mapController!
              .animateCamera(CameraUpdate.newLatLngZoom(location, 14));
        }
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

  void clearSelection() {
    selectedShipment.value = null;
    selectedCustomer.value = null;
    clusteredSelection.clear();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}

extension FirstWhereExt<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
