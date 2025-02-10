import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:final_project_admin_website/model/customer_model.dart';
import 'package:final_project_admin_website/view/widgets/common_widgets/elev_btn_1.dart';
import 'package:final_project_admin_website/view/widgets/common_widgets/get-snackbar.dart';
import 'package:final_project_admin_website/view/widgets/user_screen_widgets/customer_detail_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  final DatabaseReference customerssRef =
      FirebaseDatabase.instance.ref("customers");

  var customersList = <CustomerModel>[].obs;
  Rx<CustomerModel> currentCustomer = CustomerModel(
    uid: '',
    companyName: '',
    companyAddress: '',
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

  void showCustomerDialog(CustomerModel customer) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(30),
      titlePadding: EdgeInsets.only(top: 10.h),
      backgroundColor: Kcolor.background,
      title: "Customer Details",
      titleStyle: appStyle(
          size: 20.sp, color: Kcolor.primary, fontWeight: FontWeight.bold),
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        width: 1500.w,
        height: 500.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomerDetailWidget(
                  customerDetail: customer.uid,
                  text: "Company ID",
                ),
                SizedBox(height: 50.h),
                CustomerDetailWidget(
                  customerDetail: customer.companyName,
                  text: "Company Name",
                ),
                SizedBox(height: 50.h),
                CustomerDetailWidget(
                  customerDetail: customer.companyEmail,
                  text: "Company Email",
                ),
                SizedBox(height: 50.h),
                CustomerDetailWidget(
                  customerDetail: customer.accountStatus.name,
                  text: "Status",
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomerDetailWidget(
                  customerDetail: customer.companyAddress,
                  text: "Company Address",
                ),
                SizedBox(height: 50.h),
                CustomerDetailWidget(
                  customerDetail: customer.companyCity,
                  text: "Company City",
                ),
                SizedBox(height: 50.h),
                CustomerDetailWidget(
                  customerDetail: customer.companyPhoneNumber,
                  text: "Company Phone Number",
                ),
                SizedBox(height: 50.h),
                CustomerDetailWidget(
                  customerDetail: customer.companyRegistrationNumber,
                  text: "Company Registration Number",
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomerDetailWidget(
                  customerDetail: customer.companyImportLicenseNumber,
                  text: "Company Import License Number",
                ),
              ],
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
      actions: [
        customer.accountStatus.name == AccountStatus.waitingApproval.name
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevBtn1(
                      width: 200.w,
                      icon: Text(
                        "Approve",
                        style: appStyle(
                            size: 20.sp,
                            color: Kcolor.background,
                            fontWeight: FontWeight.bold),
                      ),
                      textColor: Kcolor.background,
                      bgColor: Colors.green,
                      func: () async {
                        await approveCustomer(customer.uid);
                      }),
                  SizedBox(width: 20.w),
                  ElevBtn1(
                      width: 200.w,
                      icon: Text(
                        "Decline",
                        style: appStyle(
                            size: 20.sp,
                            color: Kcolor.background,
                            fontWeight: FontWeight.bold),
                      ),
                      textColor: Kcolor.background,
                      bgColor: Colors.red,
                      func: () async {
                        await declineCustomer(customer.uid);
                      }),
                ],
              )
            : customer.accountStatus.name == AccountStatus.active.name
                ? ElevBtn1(
                    width: 200.w,
                    icon: Text(
                      "Deactivate",
                      style: appStyle(
                          size: 20.sp,
                          color: Kcolor.background,
                          fontWeight: FontWeight.bold),
                    ),
                    textColor: Kcolor.background,
                    bgColor: Colors.red,
                    func: () async {
                      await deactivateCustomer(customer.uid);
                    })
                : ElevBtn1(
                    width: 200.w,
                    icon: Text(
                      "Activate",
                      style: appStyle(
                          size: 20.sp,
                          color: Kcolor.background,
                          fontWeight: FontWeight.bold),
                    ),
                    textColor: Kcolor.background,
                    bgColor: Colors.green,
                    func: () async {
                      await activateCustomer(customer.uid);
                    }),
      ],
    );
  }

  Future<void> approveCustomer(String customerId) async {
    try {
      await customerssRef
          .child(customerId)
          .update({'accountStatus': AccountStatus.active.name});
      Get.back(); // Close the dialog
      getxSnackbar(title: "Success", msg: "Customer Approved");
    } catch (e) {
      getxSnackbar(title: "Error", msg: "Failed to approve customer: $e");
    }
  }

  Future<void> declineCustomer(String customerId) async {
    try {
      await customerssRef
          .child(customerId)
          .update({'accountStatus': AccountStatus.declined.name});
      Get.back(); // Close the dialog
      getxSnackbar(title: "Success", msg: "Customer declined");
    } catch (e) {
      getxSnackbar(title: "Error", msg: "Failed to decline customer: $e");
    }
  }

  Future<void> deactivateCustomer(String customerId) async {
    try {
      await customerssRef
          .child(customerId)
          .update({'accountStatus': AccountStatus.inactive.name});
      Get.back(); // Close the dialog
      getxSnackbar(title: "Success", msg: "Customer deactivated");
    } catch (e) {
      getxSnackbar(title: "Error", msg: "Failed to deactivate customer: $e");
    }
  }

  Future<void> activateCustomer(String customerId) async {
    try {
      await customerssRef
          .child(customerId)
          .update({'accountStatus': AccountStatus.active.name});
      Get.back(); // Close the dialog
      getxSnackbar(title: "Success", msg: "Customer activated");
    } catch (e) {
      getxSnackbar(title: "Error", msg: "Failed to activate customer: $e");
    }
  }
}
