import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/api/service_locator.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/dashboard/dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent, // status bar color
    ),
  );
  setup();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffF2FFF5),
        appBarTheme: const AppBarTheme(color: AppColor.primaryColor),
      ),
      home: const DashBoard(),
    ),
  );
}
