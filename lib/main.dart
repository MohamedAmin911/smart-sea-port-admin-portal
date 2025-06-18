import 'package:final_project_admin_website/constants/colors.dart';
import 'package:final_project_admin_website/constants/text.dart';
import 'package:final_project_admin_website/view/screens/tabs_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDBicds8Fdspr6n377IdIRLjRAsOXzL124",
      authDomain: "smart-port-8ba03.firebaseapp.com",
      databaseURL: "https://smart-port-8ba03-default-rtdb.firebaseio.com",
      projectId: "smart-port-8ba03",
      storageBucket: "smart-port-8ba03.firebasestorage.app",
      messagingSenderId: "701859352905",
      appId: "1:701859352905:web:c1ab23cb1de851117d0a98",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(MediaQuery.of(context).copyWith().size.width,
            MediaQuery.of(context).copyWith().size.height),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Smart Port Admin Panel',
            theme: ThemeData(
              scaffoldBackgroundColor: Kcolor.background,
              appBarTheme: AppBarTheme(
                toolbarHeight: 80.h,
                centerTitle: true,
                elevation: 0,
                backgroundColor: Kcolor.background,
                iconTheme: const IconThemeData(size: 60),
                titleTextStyle: appStyle(
                        size: 30.sp,
                        color: Kcolor.primary,
                        fontWeight: FontWeight.bold)
                    .copyWith(letterSpacing: 4.r),
              ),
              colorScheme: ColorScheme.fromSeed(seedColor: Kcolor.background),
              useMaterial3: false,
            ),
            home: const TabsScreen(),
            // PostContainerScreen(),
            // TestContainerDataUI(),
            // LogInScreen(),
          );
        });
  }
}


//flutter run -d chrome --web-port 8080