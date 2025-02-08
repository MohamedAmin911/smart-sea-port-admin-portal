import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:final_project_admin_website/model/order_model.dart';
import 'package:final_project_admin_website/view/widgets/common_widgets/elev_btn_1.dart';
import 'package:final_project_admin_website/view/widgets/common_widgets/get-snackbar.dart';
import 'package:final_project_admin_website/view/widgets/order_Screen_widgets/shipment_detail_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final RxList<ShipmentModel> orders = <ShipmentModel>[].obs;
  var isLoading = false.obs;
  final DatabaseReference _shipmentRef =
      FirebaseDatabase.instance.ref().child('shipments');
  @override
  void onInit() async {
    super.onInit();
    await fetchAllShipments();
  }

  // Fetch all shipments
  Future<void> fetchAllShipments() async {
    _shipmentRef.onValue.listen((event) {
      final List<ShipmentModel> updatedShipments = [];
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          Map<String, dynamic> shipmentData = Map<String, dynamic>.from(value);
          updatedShipments.add(ShipmentModel.fromFirebase(shipmentData));
        });
        orders.value = updatedShipments;
      }
    });
  }

  void showShipmentDialog(ShipmentModel shipment) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(30),
      titlePadding: EdgeInsets.only(top: 10.h),
      backgroundColor: Kcolor.background,
      title: "Shipment Details",
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
                ShipmentDetailWidget(
                  shipmentDetail: shipment.shipmentId,
                  text: "Shipment ID",
                ),
                SizedBox(height: 50.h),
                ShipmentDetailWidget(
                  shipmentDetail: shipment.senderName,
                  text: "Customer",
                ),
                SizedBox(height: 50.h),
                ShipmentDetailWidget(
                  shipmentDetail: shipment.senderId,
                  text: "Customer Id",
                ),
                SizedBox(height: 50.h),
                ShipmentDetailWidget(
                  shipmentDetail: shipment.shipmentStatus.name,
                  text: "Status",
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShipmentDetailWidget(
                  shipmentDetail: shipment.receiverAddress,
                  text: "Destination",
                ),
              ],
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
      actions: [
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
            func: () {
              approveShipment(shipment.shipmentId);
            }),
        SizedBox(width: 20.w),
        ElevBtn1(
            width: 200.w,
            icon: Text(
              "Cancel",
              style: appStyle(
                  size: 20.sp,
                  color: Kcolor.background,
                  fontWeight: FontWeight.bold),
            ),
            textColor: Kcolor.background,
            bgColor: Colors.red,
            func: () {
              cancelShipment(shipment.shipmentId);
            }),
      ],
    );
  }

  Future<void> approveShipment(String shipmentId) async {
    try {
      await _shipmentRef
          .child(shipmentId)
          .update({'shipmentStatus': ShipmentStatus.inTransit.name});
      Get.back(); // Close the dialog
      getxSnackbar(title: "Success", msg: "Shipment Approved");
    } catch (e) {
      getxSnackbar(title: "Error", msg: "Failed to approve shipment: $e");
    }
  }

  Future<void> cancelShipment(String shipmentId) async {
    try {
      await _shipmentRef
          .child(shipmentId)
          .update({'shipmentStatus': ShipmentStatus.cancelled.name});
      Get.back(); // Close the dialog
      getxSnackbar(title: "Success", msg: "Shipment Cancelled");
    } catch (e) {
      getxSnackbar(title: "Error", msg: "Failed to cancel shipment: $e");
    }
  }
}
