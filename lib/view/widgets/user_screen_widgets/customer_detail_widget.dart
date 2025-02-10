import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerDetailWidget extends StatelessWidget {
  const CustomerDetailWidget({
    super.key,
    required this.text,
    required this.customerDetail,
  });
  final String customerDetail;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          // width: 70.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: Kcolor.primary,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Center(
            child: Text(
              maxLines: 1,
              text,
              style: appStyle(
                  size: 10.sp,
                  color: Kcolor.background,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          customerDetail,
          style: appStyle(
              size: 20.sp, color: Kcolor.primary, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
