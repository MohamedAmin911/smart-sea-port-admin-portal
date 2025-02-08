class CustomerModel {
  final String uid;
  final String companyName;
  final String companyAddress;
  final String isBlocked;
  final String companyEmail;
  final String companyPhoneNumber;
  final String companyCity;
  final String companyRegistrationNumber;
  final String companyImportLicenseNumber;
  final List<String> orders;
  CustomerModel({
    this.uid = "",
    required this.companyName,
    required this.companyAddress,
    required this.isBlocked,
    required this.companyEmail,
    required this.companyPhoneNumber,
    required this.companyCity,
    required this.companyRegistrationNumber,
    required this.companyImportLicenseNumber,
    this.orders = const [],
  });
  // Convert a Map object into a User object
  factory CustomerModel.fromFirebase(Map<String, dynamic> json) {
    return CustomerModel(
      uid: json['uid'] as String,
      companyName: json['companyName'] as String,
      companyAddress: json['companyAddress'] as String,
      isBlocked: json['isBlocked'] as String,
      companyEmail: json['companyEmail'] as String,
      companyPhoneNumber: json['companyPhoneNumber'] as String,
      companyCity: json['companyCity'] as String,
      companyRegistrationNumber: json['companyRegistrationNumber'] as String,
      companyImportLicenseNumber: json['companyImportLicenseNumber'] as String,
      orders: json["orders"] != null
          ? List<String>.from(json["orders"].map((x) => x))
          : [], // If null, return an empty list
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'companyName': companyName,
      'companyAddress': companyAddress,
      'isBlocked': isBlocked,
      'companyEmail': companyEmail,
      'companyPhoneNumber': companyPhoneNumber,
      'companyCity': companyCity,
      'companyRegistrationNumber': companyRegistrationNumber,
      'companyImportLicenseNumber': companyImportLicenseNumber,
      "orders": orders,
    };
  }
}
