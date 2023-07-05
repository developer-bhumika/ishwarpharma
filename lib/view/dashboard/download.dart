import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/dashboard/contact_us_screen.dart';
import 'package:ishwarpharma/view/dashboard/product_catalog_screen.dart';
import 'package:ishwarpharma/view/dashboard/price_list_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen>
    with TickerProviderStateMixin {
  final productController = Get.find<ProductController>();
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    getStoragePermission();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    productController.getDownloads();
    productController.getDownLoadProduct();
  }

  getStoragePermission() async {
    await [
      Permission.storage,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          shadowColor: AppColor.borderColor2,
          title: Image.asset(
            AppImage.logo,
            height: 32,
            width: 95,
            fit: BoxFit.fill,
          ),
          actions: [
            InkWell(
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.clear();
                if (await productController.isInternet()) {
                  productController.reLoad.value = true;
                  await productController.getCompany();
                  await productController.getSlider();
                  await productController.focusProduct();
                  await productController.newArrival();
                  await productController.getProduct(1);
                  await productController.getCart();
                  await productController.getHistory();
                  productController.reLoad.value = false;
                  Get.snackbar(
                    "Success",
                    "Data reload successfully",
                    messageText: const Text(
                      "Data reload successfully",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: AppColor.primaryColor),
                    ),
                    backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                    colorText: AppColor.primaryColor,
                  );
                } else {
                  Get.snackbar("Network", "Check your internet connection",
                      messageText: const Text(
                        "Check your internet connection",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                      colorText: AppColor.primaryColor);
                }
              },
              child: Obx(
                () => productController.reLoad.value
                    ? const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                        child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                                color: AppColor.primaryColor)),
                      )
                    : SvgPicture.asset(AppImage.refresh),
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
                onTap: () {
                  Get.to(const ContactUsScreen());
                },
                child: SvgPicture.asset(AppImage.contactUs)),
            const SizedBox(width: 14),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 14,
            ),
            InkWell(
              onTap: () {
                Get.to(PriceListScreen());
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    SvgPicture.asset(AppImage.priceList),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CommonText(
                            text: "Download Price List",
                            color: AppColor.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Expanded(
                                child: CommonText(
                                  text:
                                      "Discover Our Pharmaceutical Treasure Trove",
                                  color: AppColor.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 15),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColor.grey,
                                size: 22,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                Get.to(ProductCatalogScreen());
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    SvgPicture.asset(AppImage.catalogue),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CommonText(
                            text: "Download Product Catalogue",
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Expanded(
                                child: CommonText(
                                  text:
                                      "Dive into Our Extensive Product Range - Download Now!",
                                  color: AppColor.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 15),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColor.grey,
                                size: 22,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
