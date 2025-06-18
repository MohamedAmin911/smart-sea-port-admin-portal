// Enum for shipment status
enum ShipmentStatus {
  waitingApproval,
  onHold,
  cancelled,
  waitngPayment,
  inTransit,
  delivered,
  enteredPort,
  unLoaded,
  waitingPickup,
}

class ShipmentModel {
  String shipmentId = "";
  final String senderId;
  final String receiverName;
  final String senderAddress;
  final String submitedDate;
  final String shipmentType;
  final Map<String, dynamic> shipmentSize;
  final int ContainerStoredTrigger;

  final int PortEntryTrigger;

  final String receiverAddress;
  final ShipmentStatus shipmentStatus;
  final double shipmentWeight;

  final double shippingCost;

  final String orderId;
  final bool isPaid;
  final String estimatedDeliveryDate;

  ShipmentModel({
    required this.submitedDate,
    this.shipmentId = "",
    required this.senderId,
    required this.receiverName,
    required this.senderAddress,
    this.estimatedDeliveryDate = "",
    required this.receiverAddress,
    required this.shipmentType,
    required this.shipmentSize,
    required this.shipmentStatus,
    required this.shipmentWeight,
    this.shippingCost = 0,
    this.isPaid = false,
    this.orderId = "",
    this.PortEntryTrigger = 0,
    this.ContainerStoredTrigger = 0,
  });

  // Convert a Map object into a ShipmentModel object
  factory ShipmentModel.fromFirebase(Map<String, dynamic> json) {
    return ShipmentModel(
      shipmentType: json['shipmentType'] as String? ?? "",
      submitedDate: json['submitedDate'] as String? ?? "",
      shipmentId: json['shipmentId'] as String? ?? "",
      senderId: json['senderId'] as String? ?? "",
      receiverName: json['receiverName'] as String? ?? "",
      senderAddress: json['senderAddress'] as String? ?? "",
      receiverAddress: json['receiverAddress'] as String? ?? "",
      shipmentStatus: ShipmentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['shipmentStatus'],
        orElse: () => ShipmentStatus.waitingApproval,
      ),
      shipmentWeight: (json['shipmentWeight'] as num?)?.toDouble() ?? 0.0,
      shipmentSize: _convertShipmentSize(json['shipmentSize']),
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ?? 0.0,
      orderId: json['orderId'] as String? ?? "",
      isPaid: json['isPaid'] as bool? ?? false,
      estimatedDeliveryDate: json['estimatedDeliveryDate'] as String? ?? "",
      PortEntryTrigger: json['PortEntryTrigger'] as int? ?? 0,
      ContainerStoredTrigger: json['ContainerStoredTrigger'] as int? ?? 0,
    );
  }
  static Map<String, dynamic> _convertShipmentSize(dynamic sizeData) {
    if (sizeData is Map) {
      return Map<String, dynamic>.from(sizeData);
    }
    return {}; // Return empty map if conversion fails
  }

  // Convert a ShipmentModel object into a Map
  Map<String, dynamic> toJson() {
    return {
      'shipmentType': shipmentType,
      'submitedDate': submitedDate,
      'shipmentId': shipmentId,
      'senderId': senderId,
      'receiverName': receiverName,
      'senderAddress': senderAddress,
      'receiverAddress': receiverAddress,
      'shipmentStatus': shipmentStatus.toString().split('.').last,
      'shipmentWeight': shipmentWeight,
      'shipmentSize': shipmentSize,
      'shippingCost': shippingCost,
      'orderId': orderId,
      'isPaid': isPaid,
      'estimatedDeliveryDate': estimatedDeliveryDate,
      'PortEntryTrigger': PortEntryTrigger,
      'ContainerStoredTrigger': ContainerStoredTrigger,
    };
  }
}
