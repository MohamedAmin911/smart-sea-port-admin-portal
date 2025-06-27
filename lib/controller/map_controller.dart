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
  final List<ShipmentStatus> _inTransitStatuses = const [
    ShipmentStatus.inTransit,
  ];
  BitmapDescriptor? shipIcon;
  BitmapDescriptor? portIcon;
  static const LatLng portSaidLocation = LatLng(31.26, 32.30);

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

  void _listenToAllData() {
    _shipmentsRef.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        _allShipments = (event.snapshot.value as Map)
            .values
            .map((e) =>
                ShipmentModel.fromFirebase(Map<String, dynamic>.from(e as Map)))
            .toList();
      } else {
        _allShipments = [];
      }
      _buildMarkersFromState();
    });

    _customersRef.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        _allCustomers = (event.snapshot.value as Map)
            .values
            .map((e) =>
                CustomerModel.fromFirebase(Map<String, dynamic>.from(e as Map)))
            .toList();
      } else {
        _allCustomers = [];
      }
    });

    _positionsRef.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        _latestPositions =
            Map<String, dynamic>.from(event.snapshot.value as Map);
      } else {
        _latestPositions = {};
      }
      _buildMarkersFromState();
    });
  }

  void _buildMarkersFromState() {
    final newMarkers = <Marker>{};

    newMarkers.add(Marker(
      markerId: const MarkerId('permanent_port_marker'),
      position: portSaidLocation,
      icon: portIcon ?? BitmapDescriptor.defaultMarker,
      onTap: () {
        handleMarkerTap(portSaidLocation);
      },
    ));

    final inTransitShipments = _allShipments
        .where((s) =>
            _inTransitStatuses.contains(s.shipmentStatus) &&
            _latestPositions.containsKey(s.shipmentId))
        .toList();

    for (var shipment in inTransitShipments) {
      final posData = Map<String, dynamic>.from(
          _latestPositions[shipment.shipmentId] as Map);
      final location = LatLng(posData['latitude'], posData['longitude']);

      newMarkers.add(
        Marker(
          markerId: MarkerId(shipment.shipmentId),
          position: location,
          icon: shipIcon ?? BitmapDescriptor.defaultMarker,
          onTap: () {
            handleMarkerTap(location);
          },
        ),
      );
    }

    markers.value = newMarkers;
  }

  // --- CORRECTED LOGIC FOR HANDLING TAPS ---
  void handleMarkerTap(LatLng tappedLocation) {
    // Case 1: The main Port Said marker was tapped
    if (tappedLocation == portSaidLocation) {
      // A shipment is considered "at the port" if its status is anything OTHER than inTransit.
      final shipmentsAtPort = _allShipments
          .where((s) => !_inTransitStatuses.contains(s.shipmentStatus))
          .toList();

      if (shipmentsAtPort.isNotEmpty) {
        selectedShipment.value = null;
        clusteredSelection.value = shipmentsAtPort;
      } else {
        Get.snackbar(
            "Port Said", "No shipments currently at the port to display.",
            snackPosition: SnackPosition.BOTTOM);
      }
      return;
    }

    // Case 2: An individual in-transit ship marker was tapped
    final itemsAtLocation = _allShipments.where((s) {
      if (_latestPositions.containsKey(s.shipmentId)) {
        final posData =
            Map<String, dynamic>.from(_latestPositions[s.shipmentId] as Map);
        return LatLng(posData['latitude'], posData['longitude']) ==
            tappedLocation;
      }
      return false;
    }).toList();

    if (itemsAtLocation.isNotEmpty) {
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
          // mapController!
          //     .animateCamera(CameraUpdate.newLatLngZoom(location, 14));
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
