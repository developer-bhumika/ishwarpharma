import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/company_card.dart';
import 'package:ishwarpharma/view/dashboard/contact_us_screen.dart';
import 'package:ishwarpharma/view/dashboard/products_screen.dart';
import 'package:ishwarpharma/view/dashboard/view_all_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final productController = Get.find<ProductController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffE5EBF4).withOpacity(0.32),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 16),
                        Image.asset(
                          AppImage.logo,
                          height: 32,
                          width: 95,
                          fit: BoxFit.fill,
                        ),
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
                              await productController.focusProduct();
                              await productController.newArrival();
                              await productController.getHistory();
                              productController.reLoad.value = false;
                              Get.snackbar(
                                "Success",
                                "Data reload successfully",
                                messageText: const Text(
                                  "Data reload successfully",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 13, color: AppColor.primaryColor),
                                ),
                                backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                                colorText: AppColor.primaryColor,
                              );
                            } else {
                              Get.snackbar(
                                "Network",
                                "Check your internet connection",
                                messageText: const Text(
                                  "Check your internet connection",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                                backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                                colorText: AppColor.primaryColor,
                              );
                            }
                          },
                          child: Obx(
                            () => productController.reLoad.value
                                ? const SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(color: AppColor.primaryColor))
                                : SvgPicture.asset(AppImage.refresh),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                            onTap: () {
                              Get.to(const ContactUsScreen());
                            },
                            child: SvgPicture.asset(AppImage.contactUs)),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      color: AppColor.borderColor2,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 10),
                      child: InkWell(
                        onTap: () {
                          productController.search.clear();
                          Get.to(ProductsScreen());
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(AppImage.search),
                            const SizedBox(width: 12),
                            const CommonText(
                              color: Color(0xff909396),
                              text: "Search Medicine",
                              fontSize: 14,
                            ),
                            const Spacer(),
                            SvgPicture.asset(AppImage.filter)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 200,
              width: Get.width,
              child: Obx(
                () => productController.companyLoad.value
                    ? Padding(
                        padding: const EdgeInsets.all(14.0),
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
                          enableInfiniteScroll: false,
                        ),
                        items: productController.sliderList.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(left: 12.0, right: 2),
                                transform: Matrix4.translationValues(-350 / 20, 0, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: i.sliderUrl ?? "",
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        SizedBox(height: 25, width: 25, child: ProgressView()),
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
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CommonText(
                      color: AppColor.textColor,
                      text: "Explore Companies",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(ViewAllScreen());
                      },
                      child: Row(
                        children: const [
                          CommonText(
                            color: AppColor.primaryColor,
                            text: "View All",
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: AppColor.primaryColor,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => productController.companyLoad.value
                  ? const Center(child: CircularProgressIndicator(color: AppColor.primaryColor))
                  : productController.companyList.isEmpty
                      ? const Center(
                          child: CommonText(
                            fontSize: 20,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w700,
                            color: AppColor.primaryColor,
                            text: "No Company Available",
                          ),
                        )
                      : Container(
                          color: Colors.white,
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: MediaQuery.of(context).size.aspectRatio / 0.5,
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                productController.companyList.length >= 3 ? 3 : productController.companyList.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                productController.search.text = productController.companyList[index].name!;
                                productController.searchProduct(productController.search.text);
                                Get.to(ProductsScreen());
                                // BottomNavigationBar navigationBar =
                                //     bottomWidgetKey.currentWidget as BottomNavigationBar;
                                // navigationBar.onTap!(1);
                              },
                              child: CompanyCard(
                                imageUrl: productController.companyList[index].logoUrl ?? "",
                                companyName: productController.companyList[index].name ?? "",
                              ),
                            ),
                          ),
                        ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: CommonText(
                      color: AppColor.textColor,
                      text: "Focus Products",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => productController.focusLoad.value
                        ? Padding(
                            padding: const EdgeInsets.all(14.0),
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
                              enableInfiniteScroll: false,
                            ),
                            items: productController.focusDataList.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(left: 12.0, right: 2),
                                    transform: Matrix4.translationValues(-350 / 20, 0, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: i.focusUrl ?? "",
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            SizedBox(height: 25, width: 25, child: ProgressView()),
                                        errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: CommonText(
                      color: AppColor.textColor,
                      text: "New Arrivals",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => productController.newArrivalLoad.value
                        ? Padding(
                            padding: const EdgeInsets.all(14.0),
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
                              enableInfiniteScroll: false,
                            ),
                            items: productController.newArrivalList.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(left: 12.0, right: 2),
                                    transform: Matrix4.translationValues(-350 / 20, 0, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: i.arrivalUrl ?? "",
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            SizedBox(height: 25, width: 25, child: ProgressView()),
                                        errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
