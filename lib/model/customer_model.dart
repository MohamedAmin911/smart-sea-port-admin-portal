enum AccountStatus {
  waitingApproval,
  active,
  inactive,
  declined,
}

class CustomerModel {
  final String uid;
  final String companyName;
  final String companyAddress;
  final String companyEmail;
  final String companyPhoneNumber;
  final String companyCity;
  final String companyRegistrationNumber;
  final String companyImportLicenseNumber;
  final List<String> orders;
  final AccountStatus accountStatus;

  CustomerModel({
    this.uid = "",
    required this.companyName,
    required this.companyAddress,
    required this.companyEmail,
    required this.companyPhoneNumber,
    required this.companyCity,
    required this.companyRegistrationNumber,
    required this.companyImportLicenseNumber,
    this.orders = const [],
    this.accountStatus = AccountStatus.waitingApproval,
  });
  // Convert a Map object into a User object
  factory CustomerModel.fromFirebase(Map<String, dynamic> json) {
    return CustomerModel(
      uid: json['uid'] as String? ?? "",
      companyName: json['companyName'] as String? ?? "",
      companyAddress: json['companyAddress'] as String? ?? "",
      companyEmail: json['companyEmail'] as String? ?? "",
      companyPhoneNumber: json['companyPhoneNumber'] as String? ?? "",
      companyCity: json['companyCity'] as String? ?? "",
      companyRegistrationNumber:
          json['companyRegistrationNumber'] as String? ?? "",
      companyImportLicenseNumber:
          json['companyImportLicenseNumber'] as String? ?? "",
      orders: json["orders"] != null
          ? List<String>.from(json["orders"].map((x) => x))
          : [],
      accountStatus: AccountStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['accountStatus'],
        orElse: () => AccountStatus.waitingApproval,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'companyName': companyName,
      'companyAddress': companyAddress,
      'companyEmail': companyEmail,
      'companyPhoneNumber': companyPhoneNumber,
      'companyCity': companyCity,
      'companyRegistrationNumber': companyRegistrationNumber,
      'companyImportLicenseNumber': companyImportLicenseNumber,
      "orders": orders,
      "accountStatus": accountStatus.toString().split('.').last,
    };
  }
}
