// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:final_project_admin_website/controller/estimate_costs_controller.dart';
import 'package:final_project_admin_website/model/shipment_model.dart';
import 'package:final_project_admin_website/view/widgets/common_widgets/elev_btn_1.dart';
import 'package:final_project_admin_website/view/widgets/common_widgets/get-snackbar.dart';
import 'package:final_project_admin_website/view/widgets/order_Screen_widgets/shipment_detail_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderController extends GetxController {
  final EstimateCostsController estimateCostsController =
      Get.put(EstimateCostsController());
  final RxList<ShipmentModel> orders = <ShipmentModel>[].obs;
  var isLoading = false.obs;
  final DatabaseReference _shipmentRef =
      FirebaseDatabase.instance.ref().child('shipments');

  RxDouble shippingCost = 0.0.obs;

  RxString estimatedDate = "".obs;
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

  Future<void> fetchShipmentCosts(String shipmentId) async {
    _shipmentRef.child(shipmentId).onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          Map<String, dynamic> shipmentData = Map<String, dynamic>.from(data);
          shippingCost.value =
              ShipmentModel.fromFirebase(shipmentData).shippingCost;
        } else {
          print('Shipment data is null');
        }
      } else {
        print('Shipment not found in the database.');
      }
    });
  }

  Future<void> fetchShipmentEstimatedDate(String shipmentId) async {
    _shipmentRef.child(shipmentId).onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          Map<String, dynamic> shipmentData = Map<String, dynamic>.from(data);
          estimatedDate.value =
              ShipmentModel.fromFirebase(shipmentData).estimatedDeliveryDate;
        } else {
          print('Shipment data is null');
        }
      } else {
        print('Shipment not found in the database.');
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
                  shipmentDetail: shipment.receiverName,
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
                  shipmentDetail: shipment.shipmentWeight.toString() + " kg",
                  text: "Weight",
                ),
                SizedBox(height: 50.h),
                ShipmentDetailWidget(
                  shipmentDetail: shipment.shipmentSize["length"] + " cm",
                  text: "length",
                ),
                SizedBox(height: 50.h),
                ShipmentDetailWidget(
                  shipmentDetail: shipment.shipmentSize["width"] + " cm",
                  text: "width",
                ),
                SizedBox(height: 50.h),
                ShipmentDetailWidget(
                  shipmentDetail: shipment.shipmentSize["height"] + " cm",
                  text: "height",
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
                SizedBox(height: 50.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ShipmentDetailWidget(
                        shipmentDetail: shippingCost.value == 0
                            ? "Waiting estimation"
                            : "${shippingCost.value} EGP",
                        text: "Costs",
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.only(top: 38.h, left: 20.w),
                      onPressed: () async {
                        int cost =
                            await estimateCostsController.estimateShipmentCost(
                          shipment.senderAddress,
                          "Egypt",
                          height: double.parse(shipment.shipmentSize["height"]),
                          length: double.parse(shipment.shipmentSize["length"]),
                          width: double.parse(shipment.shipmentSize["width"]),
                        );
                        try {
                          await _shipmentRef
                              .child(shipment.shipmentId)
                              .update({'shippingCost': cost});
                          await fetchShipmentCosts(shipment.shipmentId);
                        } catch (e) {
                          rethrow;
                        }
                      },
                      icon: const Icon(
                        Icons.calculate_rounded,
                        color: Kcolor.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ShipmentDetailWidget(
                        shipmentDetail: estimatedDate.value.isEmpty
                            ? "Waiting estimation"
                            : estimatedDate.value,
                        text: "ETA",
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.only(top: 38.h, left: 20.w),
                      onPressed: () async {
                        String date = DateFormat('yyyy-MM-dd').format(
                          await estimateCostsController.estimateArrivalDate(
                            shipment.senderAddress,
                            "Egypt",
                          ),
                        );
                        try {
                          await _shipmentRef
                              .child(shipment.shipmentId)
                              .update({'estimatedDeliveryDate': date});
                          await fetchShipmentEstimatedDate(shipment.shipmentId);
                        } catch (e) {
                          rethrow;
                        }
                      },
                      icon: const Icon(
                        Icons.calculate_rounded,
                        color: Kcolor.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
      actions: shipment.shipmentStatus.name ==
              ShipmentStatus.waitingApproval.name
          ? [
              //approve btn
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
              //on hold btn
              ElevBtn1(
                  width: 200.w,
                  icon: Text(
                    "On Hold",
                    style: appStyle(
                        size: 20.sp,
                        color: Kcolor.background,
                        fontWeight: FontWeight.bold),
                  ),
                  textColor: Kcolor.background,
                  bgColor: Colors.blue,
                  func: () {
                    onHoldShipment(shipment.shipmentId);
                  }),
              SizedBox(width: 20.w),

              //cancel btn
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
            ]
          : shipment.shipmentStatus.name == ShipmentStatus.onHold.name
              ? [
                  //approve btn
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

                  //cancel btn
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
                ]
              : shipment.shipmentStatus.name ==
                      ShipmentStatus.waitngPayment.name
                  ? [
                      Center(
                        child: Text(
                          "Waiting Payment",
                          style: appStyle(
                              size: 20.sp,
                              color: Kcolor.background,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ]
                  : shipment.shipmentStatus.name ==
                          ShipmentStatus.cancelled.name
                      ? [
                          Center(
                            child: Text(
                              "Order Cancelled",
                              style: appStyle(
                                  size: 20.sp,
                                  color: Kcolor.background,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ]
                      : shipment.shipmentStatus.name ==
                              ShipmentStatus.inTransit.name
                          ? [
                              Center(
                                child: Text(
                                  "Order In Transit",
                                  style: appStyle(
                                      size: 20.sp,
                                      color: Kcolor.background,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ]
                          : shipment.shipmentStatus.name ==
                                  ShipmentStatus.unLoaded.name
                              ? [
                                  Center(
                                    child: Text(
                                      "Order Unloaded",
                                      style: appStyle(
                                          size: 20.sp,
                                          color: Kcolor.background,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ]
                              : shipment.shipmentStatus.name ==
                                      ShipmentStatus.waitingPickup.name
                                  ? [
                                      Center(
                                        child: Text(
                                          "Waiting Pickup",
                                          style: appStyle(
                                              size: 20.sp,
                                              color: Kcolor.background,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ]
                                  : shipment.shipmentStatus.name ==
                                          ShipmentStatus.delivered.name
                                      ? [
                                          Center(
                                            child: Text(
                                              "Order Delivered",
                                              style: appStyle(
                                                  size: 20.sp,
                                                  color: Kcolor.background,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ]
                                      : [],
    );
  }

  Future<void> approveShipment(String shipmentId) async {
    try {
      await _shipmentRef
          .child(shipmentId)
          .update({'shipmentStatus': ShipmentStatus.waitngPayment.name});
      Get.back(); // Close the dialog
      getxSnackbar(title: "Success", msg: "Shipment Approved");
    } catch (e) {
      getxSnackbar(title: "Error", msg: "Failed to approve shipment: $e");
    }
  }

  Future<void> onHoldShipment(String shipmentId) async {
    try {
      await _shipmentRef
          .child(shipmentId)
          .update({'shipmentStatus': ShipmentStatus.onHold.name});
      Get.back(); // Close the dialog
      getxSnackbar(title: "Success", msg: "Shipment is on hold");
    } catch (e) {
      getxSnackbar(
          title: "Error", msg: "Failed to place shipment is on hold: $e");
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
