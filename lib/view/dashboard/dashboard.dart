import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/bottombar_controller.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/about_us_screen.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/setting/setting_screen.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(AppImage.logo),
            ),
          ),
          title:
              const CommonText(text: "Ishwar Pharma", color: AppColor.white, fontWeight: FontWeight.w800, fontSize: 20),
          actions: [
            InkWell(
                onTap: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  preferences.clear();
                  if (await productController.isInternet()) {
                    productController.reLoad.value = true;
                    await productController.getCompany();
                    await productController.getSlider();
                    await productController.getProduct();
                    await productController.getCart();
                    await productController.getHistory();
                    productController.reLoad.value = false;
                    Get.snackbar(
                      "Success",
                      "Data reload successfully",
                      messageText: Text(
                        "Data reload successfully",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.green.shade900),
                      ),
                      backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
                      colorText: Colors.green.shade900,
                    );
                  } else {
                    Get.snackbar("Network", "Check your internet connection",
                        messageText: Text(
                          "Check your internet connection",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.green.shade900,
                          ),
                        ),
                        backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
                        colorText: Colors.green.shade900);
                  }
                },
                child: Obx(
                  () => productController.reLoad.value
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 17.0),
                          child: SizedBox(
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColor.white,
                                strokeWidth: 2,
                              )),
                        )
                      : const Icon(Icons.sync),
                )),
            const SizedBox(width: 5),
            PopupMenuButton<int>(
              splashRadius: 20,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              icon: const Icon(Icons.more_vert_sharp),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 1, child: Text("Setting")),
                const PopupMenuItem(value: 2, child: Text("About Us")),
              ],
              elevation: 10,
              onSelected: (val) {
                if (val == 1) {
                  Get.to(SettingScreen());
                } else {
                  Get.to(AboutUsScreen());
                }
              },
            ),
          ],
        ),
        body: Obx(() => bottomBarController.pageList.elementAt(bottomBarController.selectedIndex.value)),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColor.primaryColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: AppColor.white,
            unselectedItemColor: AppColor.white.withOpacity(0.5),
            currentIndex: bottomBarController.selectedIndex.value,
            onTap: (v) {
              bottomBarController.selectedIndex.value = v;
            },
            items: [
              const BottomNavigationBarItem(label: "", icon: Icon(Icons.home)),
              const BottomNavigationBarItem(label: "", icon: Icon(Icons.inventory_2)),
              BottomNavigationBarItem(
                  label: "",
                  icon: badges.Badge(
                      badgeStyle: badges.BadgeStyle(badgeColor: Colors.red.shade700),
                      badgeContent: Text(
                        productController.cartList.length.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      child: const Icon(Icons.shopping_cart))),
              const BottomNavigationBarItem(label: "", icon: Icon(Icons.history)),
              const BottomNavigationBarItem(label: "", icon: Icon(Icons.download)),
              const BottomNavigationBarItem(label: "", icon: Icon(Icons.notifications_active)),
            ],
          ),
        ),
      ),
    );
  }
}
