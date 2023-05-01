import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/about_us_screen.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/dashboard/home_screen.dart';
import 'package:ishwarpharma/view/dashboard/products_screen.dart';
import 'package:ishwarpharma/view/setting/setting_screen.dart';

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
    return Scaffold(
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
          const Icon(Icons.sync),
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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColor.white),
                ),
                padding: const EdgeInsets.all(2),
                child: TabBar(
                  physics: const BouncingScrollPhysics(),
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: AppColor.primaryColor,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.white,
                  ),
                  unselectedLabelColor: AppColor.white,
                  tabs: const [
                    Tab(child: Text("Home")),
                    Tab(child: Text("Products")),
                    Tab(child: Text("Cart")),
                    Tab(child: Text("History")),
                    Tab(child: Text("Notifications")),
                    Tab(child: Text("Downloads")),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const HomeScreen(),
                ProductsScreen(),
                const CommonText(text: "3"),
                const CommonText(text: "4"),
                const CommonText(text: "5"),
                const CommonText(text: "6"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
