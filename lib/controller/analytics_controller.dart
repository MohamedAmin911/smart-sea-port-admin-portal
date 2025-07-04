import 'package:final_project_admin_website/model/customer_model.dart';
import 'package:final_project_admin_website/model/shipment_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// A simple data class to hold processed data for the Top Customers chart.
class TopCustomerData {
  final String name;
  final int shipmentCount;
  TopCustomerData({required this.name, required this.shipmentCount});
}

class AnalyticsController extends GetxController {
  // --- REAL-TIME DATA HOLDERS ---
  List<ShipmentModel> _allShipments = [];
  List<CustomerModel> _allCustomers = [];

  // --- OBSERVABLES FOR UI ---
  final isLoading = true.obs;

  // KPI Cards
  final totalRevenue = 0.0.obs;
  final totalShipments = 0.obs;
  final activeCustomers = 0.obs;
  final pendingOrders = 0.obs;

  // Charts Data
  final shipmentStatusDistribution = <String, double>{}.obs;
  final shipmentTypeDistribution = <String, double>{}.obs;
  final revenueOverTime = <FlSpot>[].obs;
  final topCustomersByShipments = <TopCustomerData>[].obs;

  // --- FIREBASE REFS ---
  final DatabaseReference _shipmentsRef =
      FirebaseDatabase.instance.ref('shipments');
  final DatabaseReference _customersRef =
      FirebaseDatabase.instance.ref('customers');

  @override
  void onInit() {
    super.onInit();
    _listenToAllData();
  }

  void _listenToAllData() {
    _shipmentsRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        _allShipments = (event.snapshot.value as Map)
            .values
            .map((e) =>
                ShipmentModel.fromFirebase(Map<String, dynamic>.from(e as Map)))
            .toList();
      } else {
        _allShipments = [];
      }
      _processAllAnalytics();
    });

    _customersRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        _allCustomers = (event.snapshot.value as Map)
            .values
            .map((e) =>
                CustomerModel.fromFirebase(Map<String, dynamic>.from(e as Map)))
            .toList();
      } else {
        _allCustomers = [];
      }
      _processAllAnalytics();
    });
  }

  void _processAllAnalytics() {
    if (_allShipments.isEmpty || _allCustomers.isEmpty) {
      isLoading.value = true;
      return;
    }

    // --- Run all calculation methods ---
    _calculateKPIs();
    _calculateShipmentStatusChart();
    _calculateShipmentTypeChart();
    _calculateRevenueChart();
    _calculateTopCustomers();

    isLoading.value = false;
  }

  // --- CALCULATION METHODS ---

  void _calculateKPIs() {
    totalRevenue.value = _allShipments
        .where((s) => s.isPaid)
        .fold(0.0, (sum, item) => sum + item.shippingCost);
    totalShipments.value = _allShipments.length;
    activeCustomers.value = _allCustomers
        .where((c) => c.accountStatus == AccountStatus.active)
        .length;
    pendingOrders.value = _allShipments
        .where((s) => s.shipmentStatus == ShipmentStatus.waitingApproval)
        .length;
  }

  void _calculateShipmentStatusChart() {
    final statusMap = <String, double>{};
    for (var shipment in _allShipments) {
      final statusName = shipment.shipmentStatus.name;
      statusMap[statusName] = (statusMap[statusName] ?? 0) + 1;
    }
    shipmentStatusDistribution.value = statusMap;
  }

  void _calculateShipmentTypeChart() {
    final typeMap = <String, double>{};
    for (var shipment in _allShipments) {
      // Capitalize for better display
      final typeName = shipment.shipmentType.isNotEmpty
          ? shipment.shipmentType[0].toUpperCase() +
              shipment.shipmentType.substring(1)
          : "Unknown";
      typeMap[typeName] = (typeMap[typeName] ?? 0) + 1;
    }
    shipmentTypeDistribution.value = typeMap;
  }

  void _calculateRevenueChart() {
    final monthlyRevenue = <int, double>{};
    final dateFormat = DateFormat('d-M-yyyy');

    for (var shipment in _allShipments) {
      if (shipment.isPaid && shipment.submitedDate.isNotEmpty) {
        try {
          final date = dateFormat.parse(shipment.submitedDate);
          final month = date.month;
          monthlyRevenue[month] =
              (monthlyRevenue[month] ?? 0) + shipment.shippingCost;
        } catch (e) {
          // Ignore dates with incorrect format
        }
      }
    }

    revenueOverTime.value = monthlyRevenue.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }

  void _calculateTopCustomers() {
    final customerShipmentCount = <String, int>{};
    for (var shipment in _allShipments) {
      customerShipmentCount[shipment.senderId] =
          (customerShipmentCount[shipment.senderId] ?? 0) + 1;
    }

    // Sort customers by shipment count
    final sortedCustomers = customerShipmentCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    topCustomersByShipments.value = sortedCustomers
        .take(5) // Get top 5
        .map((entry) {
      final customerName = _allCustomers
              .firstWhereOrNull((c) => c.uid == entry.key)
              ?.companyName ??
          "Unknown Customer";
      return TopCustomerData(name: customerName, shipmentCount: entry.value);
    }).toList();
  }
}
