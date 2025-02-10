import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:final_project_admin_website/controller/customers_controller.dart';
import 'package:final_project_admin_website/controller/order_controller.dart';
import 'package:final_project_admin_website/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class UserCardWidget extends StatefulWidget {
  const UserCardWidget({
    super.key,
    required this.customer,
  });

  final CustomerModel customer;

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  final OrderController ordersController = Get.put(OrderController());
  final CustomerController customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        onTap: () {
          customerController.showCustomerDialog(widget.customer);
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
                width: 250.w,
                child: Text(
                  maxLines: 1,
                  widget.customer.uid,
                  overflow: TextOverflow.ellipsis,
                  style: appStyle(
                      size: 18.sp,
                      color: Kcolor.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
              //name
              SizedBox(
                width: 250.w,
                child: Text(
                  maxLines: 1,
                  widget.customer.companyName,
                  overflow: TextOverflow.ellipsis,
                  style: appStyle(
                      size: 18.sp,
                      color: Kcolor.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
              //email
              SizedBox(
                width: 250.w,
                child: Text(
                  maxLines: 1,
                  widget.customer.companyEmail,
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
                    width: 160.w,
                    height: 30.h,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Kcolor.primary,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      child: Center(
                        child: Text(
                          maxLines: 1,
                          widget.customer.accountStatus.name ==
                                  "waitingApproval"
                              ? "Waiting Approval"
                              : widget.customer.accountStatus.name == "active"
                                  ? "Active"
                                  : "Inactive",
                          overflow: TextOverflow.ellipsis,
                          style: appStyle(
                              size: 12.sp,
                              color: Kcolor.background,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 90.w),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
