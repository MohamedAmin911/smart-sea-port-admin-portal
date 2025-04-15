// ignore_for_file: invalid_use_of_protected_member, deprecated_member_use

import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:final_project_admin_website/controller/customers_controller.dart';
import 'package:final_project_admin_website/controller/order_controller.dart';
import 'package:final_project_admin_website/view/widgets/order_Screen_widgets/orders_listview_widget.dart';

import 'package:final_project_admin_website/view/widgets/order_Screen_widgets/search_order_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController searchController = TextEditingController();
  final OrderController ordersController = Get.put(OrderController());
  final CustomerController customerController = Get.put(CustomerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
            child: Container(
              decoration: BoxDecoration(
                color: Kcolor.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(22.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
              child: Obx(
                () => Column(
                  children: [
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        Text(
                          "Orders Management",
                          style: appStyle(
                              size: 25.sp,
                              color: Kcolor.primary,
                              fontWeight: FontWeight.w900),
                        ),
                        const Spacer(),
                        SearchTextField(searchController: searchController),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            "Order ID",
                            style: appStyle(
                                size: 15.sp,
                                color: Kcolor.primary,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            "Date",
                            style: appStyle(
                                size: 15.sp,
                                color: Kcolor.primary,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            "From",
                            style: appStyle(
                                size: 15.sp,
                                color: Kcolor.primary,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            "To",
                            style: appStyle(
                                size: 15.sp,
                                color: Kcolor.primary,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            "Status",
                            style: appStyle(
                                size: 15.sp,
                                color: Kcolor.primary,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            "Cost",
                            style: appStyle(
                                size: 15.sp,
                                color: Kcolor.primary,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    ordersController.orders.value.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 60.h, bottom: 30.h),
                              child: Text(
                                "No Orders Yet",
                                style: appStyle(
                                    size: 18.sp,
                                    color: Kcolor.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : const OrdersListView(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
