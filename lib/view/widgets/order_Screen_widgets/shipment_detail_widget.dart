import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShipmentDetailWidget extends StatelessWidget {
  const ShipmentDetailWidget({
    super.key,
    required this.text,
    required this.shipmentDetail,
  });
  final String shipmentDetail;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: Kcolor.primary,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Center(
            child: Text(
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
          shipmentDetail,
          style: appStyle(
              size: 20.sp, color: Kcolor.primary, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
