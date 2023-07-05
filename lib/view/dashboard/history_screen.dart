import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/history_card.dart';
import 'package:ishwarpharma/view/dashboard/contact_us_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final productController = Get.find<ProductController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productController.getHistory();
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
                await productController.getProduct(1);
                await productController.getCart();
                await productController.focusProduct();
                await productController.newArrival();
                await productController.getHistory();
                productController.reLoad.value = false;
                Get.snackbar(
                  "Success",
                  "Data reload successfully",
                  messageText: Text(
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
                    messageText: Text(
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
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 8),
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
                Get.to(ContactUsScreen());
              },
              child: SvgPicture.asset(AppImage.contactUs)),
          const SizedBox(width: 14),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(
          () => productController.isHistoryLoading.value
              ? ProgressView()
              : productController.historyList.isEmpty
                  ? const Center(
                      child: CommonText(
                        fontSize: 20,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w700,
                        color: AppColor.primaryColor,
                        text: "Your History is Empty",
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: productController.historyList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) => HistoryCard(
                          products:
                              productController.historyList[index].products),
                    ),
        ),
      ),
    );
  }
}
