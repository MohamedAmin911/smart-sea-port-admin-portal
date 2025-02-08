import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20.w),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: "search orders",
        hintStyle: appStyle(
            size: 15.sp,
            color: Kcolor.primary.withOpacity(0.2),
            fontWeight: FontWeight.w400),
        suffixIcon: MaterialButton(
          shape: const CircleBorder(),
          onPressed: () {},
          child: const Icon(
            Icons.search_rounded,
            color: Kcolor.primary,
          ),
        ),
        alignLabelWithHint: true,
        constraints: const BoxConstraints(minHeight: 50, maxWidth: 400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Kcolor.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Kcolor.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Kcolor.primary, width: 2),
        ),
      ),
      style: appStyle(
          size: 15.sp, color: Kcolor.primary, fontWeight: FontWeight.w500),
    );
  }
}
