import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProductCatalogueScreen extends StatelessWidget {
  ProductCatalogueScreen({Key? key}) : super(key: key);

  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: CommonText(
          color: AppColor.textColor,
          fontSize: 18,
          text: "Product Catalogue",
          fontWeight: FontWeight.w500,
        ),
        shadowColor: AppColor.borderColor2,
        elevation: 0.75,
        centerTitle: true,
      ),
      body: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(15),
        physics: const BouncingScrollPhysics(),
        itemCount: productController.downloadPriceList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.borderColorProduct),
            borderRadius: BorderRadius.circular(6),
            color: AppColor.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: CommonText(
                    text: productController.downloadPriceList[index].name ?? "",
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              Obx(
                () => productController.downloadPriceList[index].load.value
                    ? CircularPercentIndicator(
                        radius: 20.0,
                        lineWidth: 5.0,
                        percent: productController.progressDownload.value,
                        center: CommonText(
                          text: "${(productController.progressDownload.value * 100).toInt()}%",
                          fontSize: 13,
                        ),
                        progressColor: AppColor.primaryColor,
                      )
                    : InkWell(
                        onTap: () {
                          productController.downloadPriceList[index].load.value = true;
                          productController.downloadFile(productController.downloadPriceList[index].pricepdfUrl, index);
                        },
                        child: const Icon(Icons.download, color: AppColor.primaryColor),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
