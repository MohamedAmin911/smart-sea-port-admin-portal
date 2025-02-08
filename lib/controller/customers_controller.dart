import 'package:final_project_admin_website/model/customer_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CustomerController extends GetxController {
  final DatabaseReference customerssRef =
      FirebaseDatabase.instance.ref("customers");

  var customersList = <CustomerModel>[].obs;
  Rx<CustomerModel> currentCustomer = CustomerModel(
    uid: '',
    companyName: '',
    companyAddress: '',
    isBlocked: '',
    companyEmail: '',
    companyPhoneNumber: '',
    companyCity: '',
    companyRegistrationNumber: '',
    companyImportLicenseNumber: '',
  ).obs;
  final DatabaseReference customerRef =
      FirebaseDatabase.instance.ref('customers');
  @override
  void onInit() async {
    super.onInit();
    await fetchAllCustomers();
  }

// Fetch all drivers from the database
  Future<void> fetchAllCustomers() async {
    customerRef.onValue.listen((event) {
      final List<CustomerModel> updatedUsers = [];

      // Cast the data properly to avoid type errors
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          Map<String, dynamic> userData =
              Map<String, dynamic>.from(value); // Cast each value
          updatedUsers.add(CustomerModel.fromFirebase(userData));
        });

        customersList.value = updatedUsers; // Update the observable list
      }
    });
  }
}
