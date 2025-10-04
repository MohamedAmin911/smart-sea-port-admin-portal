import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/icon-assets.dart';
import 'package:final_project_admin_website/controller/customers_controller.dart';
import 'package:final_project_admin_website/controller/order_controller.dart';
import 'package:final_project_admin_website/view/screens/analytics-screen.dart';
import 'package:final_project_admin_website/view/screens/dashboard_screen.dart';
import 'package:final_project_admin_website/view/screens/orders_screen.dart';

import 'package:final_project_admin_website/view/screens/users-screen.dart';
import 'package:final_project_admin_website/view/widgets/tabs_screen_widgets/tab-bar-widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tabs = [
    const Tab(
      text: 'Tracking',
    ),
    const Tab(
      text: 'Analytics',
    ),
    const Tab(
      text: 'Orders',
    ),
    const Tab(
      text: 'Users',
    ),
  ];
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  final OrderController ordersController = Get.put(OrderController());
  final CustomerController customerController = Get.put(CustomerController());
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        bottomOpacity: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: SizedBox(
          height: 60.h,
          width: 900.w,
          child: TabBarWidget(
              tabController: _tabController,
              tabs: _tabs,
              controller: controller),
        ),
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 15.w, top: 15.h),
          child: SvgPicture.asset(
            KIconAssets.smartPortLogo,
            color: Kcolor.primary,
            width: 100.w,
            height: 100.h,
          ),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          DashboardScreen(),
          AnalyticsScreen(),
          const OrdersScreen(),
          const UsersScreen(),
        ],
      ),
    );
  }
}
