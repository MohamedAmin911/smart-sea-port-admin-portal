import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:final_project_admin_website/controller/order_controller.dart';
import 'package:final_project_admin_website/model/shipment_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class OrderCardWidget extends StatefulWidget {
  const OrderCardWidget({
    super.key,
    required this.id,
    required this.date,
    required this.from,
    required this.to,
    required this.status,
    required this.cost,
    required this.shipment,
  });
  final String id;
  final String date;
  final String from;
  final String to;
  final String status;
  final String cost;
  final ShipmentModel shipment;

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  final OrderController ordersController = Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        onTap: () async {
          await ordersController
              .fetchShipmentEstimatedDate(widget.shipment.shipmentId);
          await ordersController.fetchShipmentCosts(widget.shipment.shipmentId);
          ordersController.showShipmentDialog(widget.shipment);
        },
        borderRadius: BorderRadius.circular(22.r),
        hoverColor: Kcolor.primary.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: Kcolor.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //id
              SizedBox(
                width: 200.w,
                child: Text(
                  maxLines: 1,
                  widget.id,
                  overflow: TextOverflow.ellipsis,
                  style: appStyle(
                      size: 18.sp,
                      color: Kcolor.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
              //date
              SizedBox(
                width: 200.w,
                child: Text(
                  maxLines: 1,
                  widget.date,
                  overflow: TextOverflow.ellipsis,
                  style: appStyle(
                      size: 18.sp,
                      color: Kcolor.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
              //from
              SizedBox(
                width: 200.w,
                child: Text(
                  maxLines: 1,
                  widget.from,
                  overflow: TextOverflow.ellipsis,
                  style: appStyle(
                      size: 18.sp,
                      color: Kcolor.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
              //to
              SizedBox(
                width: 200.w,
                child: Text(
                  maxLines: 1,
                  widget.to,
                  overflow: TextOverflow.ellipsis,
                  style: appStyle(
                      size: 18.sp,
                      color: Kcolor.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
              //status
              Row(
                children: [
                  SizedBox(
                    width: 120.w,
                    height: 30.h,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Kcolor.primary,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      child: Center(
                        child: Text(
                          maxLines: 1,
                          widget.status,
                          overflow: TextOverflow.ellipsis,
                          style: appStyle(
                              size: 12.sp,
                              color: Kcolor.background,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 80.w),
                ],
              ),

              //cost
              SizedBox(
                width: 200.w,
                child: Text(
                  maxLines: 1,
                  "${widget.cost} EGP",
                  overflow: TextOverflow.ellipsis,
                  style: appStyle(
                      size: 18.sp,
                      color: Kcolor.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
