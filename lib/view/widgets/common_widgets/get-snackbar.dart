import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

SnackbarController getxSnackbar({required String title, required String msg}) {
  return Get.snackbar("", "",
      backgroundColor: Kcolor.primary,
      titleText: Text(
        title,
        style: appStyle(
          size: 16.sp,
          color: Kcolor.background,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        msg,
        style: appStyle(
          size: 15.sp,
          color: Kcolor.background,
          fontWeight: FontWeight.w400,
        ),
      ),
      margin: EdgeInsets.only(bottom: 10.h, left: 16.w, right: 16.w),
      animationDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM);
}
