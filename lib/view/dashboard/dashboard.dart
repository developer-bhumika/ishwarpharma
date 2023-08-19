import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/bottombar_controller.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/main.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  final productController = Get.put<ProductController>(ProductController());
  final bottomBarController = Get.put<BottomBarController>(BottomBarController());

  ///for show notification
  Future<void> initFcm() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("notificationList") != null) {
      productController.notificationList.value = jsonDecode(preferences.getString("notificationList").toString());
    }
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      RemoteNotification? notification = message?.notification;
      if (notification?.body != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );

        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove('notificationList');
        print("Data:::::::${message?.notification?.title}");
        final mes = {
          'title': message?.notification?.title,
          'body': message?.notification?.body,
          'time': message?.sentTime.toString(),
        };

        productController.notificationList.add(mes);
        if (productController.notificationList.isNotEmpty) {
          await preferences.setString('notificationList', jsonEncode(productController.notificationList));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    initFcm();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.scaffoldBgColor,
        body: Obx(() => bottomBarController.pageList.elementAt(bottomBarController.selectedIndex.value)),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            key: bottomWidgetKey,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColor.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: AppColor.white,
            unselectedItemColor: AppColor.white.withOpacity(0.5),
            currentIndex: bottomBarController.selectedIndex.value,
            onTap: (v) {
              bottomBarController.selectedIndex.value = v;
              if (bottomBarController.selectedIndex.value != 1) {
                productController.search.clear();
              }
            },
            items: [
              BottomNavigationBarItem(
                  label: "", icon: SvgPicture.asset(AppImage.home), activeIcon: SvgPicture.asset(AppImage.homeColor)),
              BottomNavigationBarItem(
                  label: "",
                  icon: badges.Badge(
                      badgeStyle: const badges.BadgeStyle(badgeColor: AppColor.primaryColor),
                      badgeContent: Text(
                        productController.cartList.length.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      child: SvgPicture.asset(AppImage.cart)),
                  activeIcon: badges.Badge(
                      badgeStyle: const badges.BadgeStyle(badgeColor: AppColor.primaryColor),
                      badgeContent: Text(
                        productController.cartList.length.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      child: SvgPicture.asset(AppImage.cartColor))),
              BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(AppImage.download),
                  activeIcon: SvgPicture.asset(AppImage.downloadColor)),
              BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(AppImage.history),
                  activeIcon: SvgPicture.asset(AppImage.historyColor)),
              BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(AppImage.profile),
                  activeIcon: SvgPicture.asset(AppImage.profileColor)),
            ],
          ),
        ),
      ),
    );
  }
}
