import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/about_us_screen.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/dashboard/cart_screen.dart';
import 'package:ishwarpharma/view/dashboard/history_screen.dart';
import 'package:ishwarpharma/view/dashboard/home_screen.dart';
import 'package:ishwarpharma/view/dashboard/notification_screen.dart';
import 'package:ishwarpharma/view/dashboard/products_screen.dart';
import 'package:ishwarpharma/view/setting/setting_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  TabController? _tabController;
  final productController = Get.put<ProductController>(ProductController());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
          title: const CommonText(
            text: "Ishwar Pharma",
            color: AppColor.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
          actions: [
            InkWell(
                onTap: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  preferences.clear();
                  if (await productController.isInternet()) {
                    productController.reLoad.value = true;
                    await productController.getCompany();
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
                        backgroundColor: Color(0xff81B29A).withOpacity(0.9),
                        colorText: Colors.green.shade900);
                  }
                },
                child: Obx(
                  () => productController.reLoad.value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 17.0),
                          child: const SizedBox(
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
        body: Column(
          children: [
            Container(
              height: 45,
              color: AppColor.primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                child: TabBar(
                  physics: const BouncingScrollPhysics(),
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: AppColor.primaryColor,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.white,
                  ),
                  indicatorColor: AppColor.white,
                  unselectedLabelColor: AppColor.white,
                  tabs: [
                    const Tab(child: Text("Home")),
                    const Tab(child: Text("Products")),
                    Tab(
                      child: Obx(
                        () => productController.cartList.isEmpty
                            ? const Text("Cart")
                            : badges.Badge(
                                badgeStyle: badges.BadgeStyle(
                                  badgeColor: Colors.red.shade700,
                                ),
                                position: badges.BadgePosition.topEnd(top: -12, end: -15),
                                badgeContent: Text(
                                  productController.cartList.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Text(
                                  'Cart',
                                ),
                              ),
                      ),
                    ),
                    const Tab(child: Text("History")),
                    const Tab(child: Text("Notifications")),
                    const Tab(child: Text("Downloads")),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  HomeScreen(tabController: _tabController),
                  ProductsScreen(),
                  CartScreen(),
                  HistoryScreen(),
                  NotificationScreen(),
                  const Center(child: CommonText(text: "Downloads")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
