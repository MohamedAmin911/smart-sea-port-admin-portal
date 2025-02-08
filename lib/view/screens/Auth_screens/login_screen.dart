import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/icon-assets.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:final_project_admin_website/controller/auth_controller.dart';
import 'package:final_project_admin_website/view/screens/tabs_screen.dart';
import 'package:final_project_admin_website/view/widgets/common_widgets/elev_btn_1.dart';
import 'package:final_project_admin_website/view/widgets/common_widgets/get-snackbar.dart';
import 'package:final_project_admin_website/view/widgets/styled_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600; // Check for wide screens
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        bottomOpacity: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "ADMIN LOGIN",
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 400.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50.h),
                      // Email Field
                      StyledFormField(
                        width: 400,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        hintText: 'Username',
                        prefixIcon: Icons.email_rounded,
                        controller: _emailController,
                      ),
                      SizedBox(height: 10.h),
                      // Password Field
                      StyledFormField(
                        width: 400,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: 'Password',
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      SizedBox(height: 15.h),

                      // LogIn Button
                      ElevBtn1(
                        width: isWideScreen ? 400.w : double.infinity,
                        icon: Text(
                          "LOGIN",
                          style: appStyle(
                            size: 15.sp,
                            color: Kcolor.background,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        textColor: Kcolor.background,
                        bgColor: Kcolor.primary,
                        func: () {
                          bool isAuth =
                              _authController.checkUserNameAndPassword(
                                  _emailController.text,
                                  _passwordController.text);
                          if (isAuth) {
                            Get.off(const TabsScreen());
                          } else {
                            getxSnackbar(
                                title: 'Error',
                                msg: 'Invalid Username or Password');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
