import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/main.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/about_us_screen.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/company_card.dart';
import 'package:ishwarpharma/view/setting/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final productController = Get.find<ProductController>();
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: const Color(0xffF2FFF5),
        child: Column(
          children: [
            const SizedBox(height: 280),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: Divider(
                    color: Color(0xffC8F1DC),
                    endIndent: 13,
                    thickness: 1,
                  ),
                ),
                CommonText(
                  text: "Search By Company",
                  fontSize: 14,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xffC8F1DC),
                    indent: 13,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            Obx(
              () => productController.companyLoad.value
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Center(child: CircularProgressIndicator(color: AppColor.primaryColor)),
                        ],
                      ),
                    )
                  : productController.companyList.isEmpty
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Center(
                                child: CommonText(
                                  fontSize: 20,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.primaryColor,
                                  text: "No Company Available",
                                ),
                              )
                            ],
                          ),
                        )
                      : Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.95,
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: productController.companyList.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                productController.search.text = productController.companyList[index].name!;
                                productController.searchProduct(productController.search.text);
                                BottomNavigationBar navigationBar =
                                    bottomWidgetKey.currentWidget as BottomNavigationBar;
                                navigationBar.onTap!(1);
                              },
                              child: CompanyCard(
                                imageUrl: productController.companyList[index].logoUrl ?? "",
                                companyName: productController.companyList[index].name ?? "",
                              ),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      Container(
        height: 180,
        width: Get.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColor.primaryColor, AppColor.secondaryColor],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 25),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  Image.asset(AppImage.logo),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.clear();
                      if (await productController.isInternet()) {
                        productController.reLoad.value = true;
                        await productController.getCompany();
                        await productController.getSlider();
                        await productController.getProduct(1);
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
                          ? const SizedBox(
                              width: 20,
                              child: CircularProgressIndicator(color: AppColor.white, strokeWidth: 2),
                            )
                          : SvgPicture.asset(AppImage.refresh),
                    ),
                  ),
                  const SizedBox(width: 10),
                  PopupMenuButton<int>(
                    padding: const EdgeInsets.only(bottom: 10),
                    splashRadius: 20,
                    icon: SvgPicture.asset(AppImage.more),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 1, child: Text("Setting")),
                      const PopupMenuItem(value: 2, child: Text("About Us")),
                    ],
                    onSelected: (val) {
                      if (val == 1) {
                        Get.to(SettingScreen());
                      } else {
                        Get.to(AboutUsScreen());
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 85,
        child: SizedBox(
          height: 200,
          width: Get.width,
          child: Obx(
            () => productController.companyLoad.value
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        height: 160.0,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColor.white, width: 2),
                        ),
                        child: ProgressView()),
                  )
                : CarouselSlider(
                    options: CarouselOptions(
                      height: 160.0,
                      autoPlay: true,
                      // disableCenter: true,
                      viewportFraction: 0.9,
                      initialPage: 1,
                      enableInfiniteScroll: true,
                    ),
                    items: productController.sliderList.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 12.0),
                            transform: Matrix4.translationValues(-350 / 25, 0, 0),
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColor.white, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: i.sliderUrl ?? "",
                                fit: BoxFit.fill,
                                placeholder: (context, url) => SizedBox(height: 25, width: 25, child: ProgressView()),
                                errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
          ),
        ),
      )

      // Column(
      //   children: [
      //     Obx(
      //       () => productController.companyLoad.value
      //           ? SizedBox(height: 160, width: Get.width, child: ProgressView())
      //           : CarouselSlider(
      //               options: CarouselOptions(height: 160.0, autoPlay: true, viewportFraction: 1),
      //               items: productController.sliderList.map((i) {
      //                 return Builder(
      //                   builder: (BuildContext context) {
      //                     return Container(
      //                       width: MediaQuery.of(context).size.width,
      //                       margin: const EdgeInsets.symmetric(horizontal: 5.0),
      //                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      //                       child: ClipRRect(
      //                         borderRadius: BorderRadius.circular(10),
      //                         child: CachedNetworkImage(
      //                           imageUrl: i.sliderUrl ?? "",
      //                           fit: BoxFit.fill,
      //                           placeholder: (context, url) => SizedBox(height: 25, width: 25, child: ProgressView()),
      //                           errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                 );
      //               }).toList(),
      //             ),
      //     ),
      //     const SizedBox(height: 15),
      //
      //   ],
      // ),
    ]);
  }
}
