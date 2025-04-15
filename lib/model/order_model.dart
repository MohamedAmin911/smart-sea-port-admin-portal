// Enum for shipment status
enum ShipmentStatus {
  waitingApproval,
  onHold,
  cancelled,
  waitngPayment,
  inTransit,
  unLoading,
  waitingPickup,
  delivered,
}

class ShipmentModel {
  String shipmentId = "";
  final String senderId;
  final String senderName;
  final String senderAddress;
  final String submitedDate;
  final String shipmentType;
  final Map<String, dynamic> shipmentSize;
  // final String receiverId;
  // final String receiverName;
  final String receiverAddress;
  final ShipmentStatus shipmentStatus;
  final double shipmentWeight;
  // final String trackingNumber;
  // final DateTime shipmentDate;
  // final DateTime estimatedDeliveryDate;
  final double shippingCost;
  final bool isDelayed;

  ShipmentModel({
    required this.submitedDate,
    this.shipmentId = "",
    required this.senderId,
    required this.senderName,
    required this.senderAddress,
    // required this.receiverId,
    // required this.receiverName,
    required this.receiverAddress,
    required this.shipmentType,
    required this.shipmentSize,
    required this.shipmentStatus,
    required this.shipmentWeight,
    // required this.trackingNumber,
    // required this.shipmentDate,
    // required this.estimatedDeliveryDate,
    this.shippingCost = 0,
    this.isDelayed = false,
  });

  // Convert a Map object into a ShipmentModel object
  factory ShipmentModel.fromFirebase(Map<String, dynamic> json) {
    return ShipmentModel(
      shipmentType: json['shipmentType'] as String,
      submitedDate: json['submitedDate'] as String,
      shipmentId: json['shipmentId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAddress: json['senderAddress'] as String,
      // receiverId: json['receiverId'] as String,
      // receiverName: json['receiverName'] as String,
      receiverAddress: json['receiverAddress'] as String,
      shipmentStatus: ShipmentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['shipmentStatus'],
        orElse: () => ShipmentStatus.waitingApproval, // Default if invalid
      ),
      shipmentWeight: (json['shipmentWeight'] as num).toDouble(),
      shipmentSize: _convertShipmentSize(json['shipmentSize']),
      // trackingNumber: json['trackingNumber'] as String,
      // shipmentDate: DateTime.parse(json['shipmentDate']),
      // estimatedDeliveryDate: DateTime.parse(json['estimatedDeliveryDate']),
      shippingCost: (json['shippingCost'] as num).toDouble(),
      isDelayed: json['isDelayed'] as bool? ?? false,
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
      'senderName': senderName,
      'senderAddress': senderAddress,
      // 'receiverId': receiverId,
      // 'receiverName': receiverName,
      'receiverAddress': receiverAddress,
      'shipmentStatus':
          shipmentStatus.toString().split('.').last, // Save as string
      'shipmentWeight': shipmentWeight,
      'shipmentSize': shipmentSize,
      // 'trackingNumber': trackingNumber,
      // 'shipmentDate': shipmentDate.toIso8601String(),
      // 'estimatedDeliveryDate': estimatedDeliveryDate.toIso8601String(),
      'shippingCost': shippingCost,
      'isDelayed': isDelayed,
    };
  }
}
