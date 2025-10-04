import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledFormField extends StatelessWidget {
  const StyledFormField(
      {super.key,
      required this.hintText,
      this.prefixIcon,
      required this.keyboardType,
      this.validator,
      required this.obscureText,
      this.controller,
      required this.width,
      this.suffixIcon});
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextEditingController? controller;
  final int width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: 80.h,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        minLines: 1,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: appStyle(
              size: 13.sp,
              color: Kcolor.primary.withOpacity(0.2),
              fontWeight: FontWeight.w400),
          suffix: suffixIcon,
          prefixIcon: Icon(prefixIcon, color: Kcolor.primary),
          alignLabelWithHint: true,
          constraints: BoxConstraints(minHeight: 50.h, maxWidth: 400.w),
          errorStyle: appStyle(
              size: 10.sp, color: Colors.red, fontWeight: FontWeight.w500),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: const BorderSide(color: Kcolor.primary),
          ),
          errorMaxLines: 1,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: const BorderSide(color: Kcolor.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: BorderSide(color: Kcolor.primary.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: const BorderSide(color: Kcolor.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.r),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
        style: appStyle(
            size: 15.sp, color: Kcolor.primary, fontWeight: FontWeight.w500),
      ),
    );
  }
}
