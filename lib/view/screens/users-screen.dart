// ignore_for_file: invalid_use_of_protected_member
import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:final_project_admin_website/controller/customers_controller.dart';
import 'package:final_project_admin_website/controller/order_controller.dart';
import 'package:final_project_admin_website/view/widgets/order_Screen_widgets/search_order_widget.dart';
import 'package:final_project_admin_website/view/widgets/user_screen_widgets/user_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
                            "Customers Management",
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
                              width: 250.w,
                              child: Text(
                                "Company ID",
                                style: appStyle(
                                    size: 15.sp,
                                    color: Kcolor.primary,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              width: 250.w,
                              child: Text(
                                "Company Name",
                                style: appStyle(
                                    size: 15.sp,
                                    color: Kcolor.primary,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              width: 250.w,
                              child: Text(
                                "Email",
                                style: appStyle(
                                    size: 15.sp,
                                    color: Kcolor.primary,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              width: 250.w,
                              child: Text(
                                "Status",
                                style: appStyle(
                                    size: 15.sp,
                                    color: Kcolor.primary,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ]),
                      SizedBox(height: 20.h),
                      customerController.customersList.value.isEmpty
                          ? Center(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: 60.h, bottom: 30.h),
                                child: Center(
                                  child: Text(
                                    "No Customers Yet",
                                    style: appStyle(
                                        size: 18.sp,
                                        color: Kcolor.primary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  customerController.customersList.value.length,
                              itemBuilder: (context, index) {
                                return Obx(
                                  () => UserCardWidget(
                                    customer: customerController
                                        .customersList.value[index],
                                  ),
                                );
                              }),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
