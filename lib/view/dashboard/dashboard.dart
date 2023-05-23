import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/bottombar_controller.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/main.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ishwarpharma/view/about_us_screen.dart';
import 'package:ishwarpharma/view/setting/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  final productController = Get.put<ProductController>(ProductController());
  final bottomBarController = Get.put<BottomBarController>(BottomBarController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
            },
            items: [
              BottomNavigationBarItem(
                  label: "", icon: SvgPicture.asset(AppImage.home), activeIcon: SvgPicture.asset(AppImage.homeColor)),
              BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(AppImage.search),
                  activeIcon: SvgPicture.asset(AppImage.searchColor)),
              BottomNavigationBarItem(
                  label: "",
                  icon: badges.Badge(
                      badgeStyle: const badges.BadgeStyle(badgeColor: AppColor.primaryColor),
                      badgeContent: Text(
                        productController.cartList.length.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      child: SvgPicture.asset(AppImage.cart)),
                  activeIcon: SvgPicture.asset(AppImage.cartColor)),
              BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(AppImage.history),
                  activeIcon: SvgPicture.asset(AppImage.historyColor)),
              BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(AppImage.download),
                  activeIcon: SvgPicture.asset(AppImage.downloadColor)),
              BottomNavigationBarItem(
                  label: "",
                  icon: SvgPicture.asset(AppImage.notification),
                  activeIcon: SvgPicture.asset(AppImage.notificationColor)),
            ],
          ),
        ),
      ),
    );
  }
}
