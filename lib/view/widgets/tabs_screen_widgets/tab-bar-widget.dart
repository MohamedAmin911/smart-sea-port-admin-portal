import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    super.key,
    required TabController tabController,
    required List<Tab> tabs,
    required this.controller,
  })  : _tabController = tabController,
        _tabs = tabs;

  final TabController _tabController;
  final List<Tab> _tabs;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.h, top: 5.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
      height: 50.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Kcolor.background.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(2, 3),
          ),
        ],
        color: Kcolor.background,
        borderRadius: BorderRadius.circular(33.r),
      ),
      child: Center(
        child: TabBar(
          labelStyle: appStyle(
              size: 16.sp, color: Kcolor.text, fontWeight: FontWeight.w500),
          splashBorderRadius: BorderRadius.circular(22.r),
          physics: const BouncingScrollPhysics(),
          dividerColor: Colors.transparent,
          controller: _tabController,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(33.r), color: Kcolor.primary),
          labelColor: Kcolor.background,
          unselectedLabelColor: Kcolor.primary,
          tabs: _tabs,
          onTap: (v) {
            controller.jumpToPage(v);
          },
        ),
      ),
    );
  }
}
