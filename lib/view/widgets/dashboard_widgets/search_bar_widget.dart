import 'package:final_project_admin_website/constants/text.dart';
import 'package:final_project_admin_website/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:final_project_admin_website/constants/colors.dart';

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({super.key});

  final AdminMapController controller = Get.find();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Kcolor.background,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
          )
        ],
      ),
      child: TextField(
        controller: textController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: const BorderSide(color: Kcolor.primary, width: 2),
          ),
          errorMaxLines: 1,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: const BorderSide(color: Kcolor.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: const BorderSide(color: Kcolor.primary, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: const BorderSide(
                color: Kcolor.primary, width: 2), // Thicker border on focus
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          hintText: "Search by Shipment ID, Order ID, or Customer Name...",
          hintStyle: appStyle(
              size: 12.sp,
              color: Kcolor.primary.withValues(alpha: 0.2),
              fontWeight: FontWeight.w500),
          prefixIcon: const Icon(Icons.search, color: Kcolor.primary),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              textController.clear();
            },
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            controller.searchAndSelectShipment(value);
          }
        },
      ),
    );
  }
}
