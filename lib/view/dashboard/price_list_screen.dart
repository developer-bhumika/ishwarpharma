import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PriceListScreen extends StatelessWidget {
  PriceListScreen({Key? key}) : super(key: key);
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: CommonText(
          color: AppColor.textColor,
          fontSize: 18,
          text: "Price List",
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        shadowColor: AppColor.borderColor2,
        elevation: 0.75,
      ),
      body: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15),
        itemCount: productController.downloadProductList.length,
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
                    text: productController.downloadProductList[index].name ?? "",
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              Obx(
                () => productController.downloadProductList[index].load.value
                    ? CircularPercentIndicator(
                        radius: 20.0,
                        lineWidth: 3.0,
                        percent: productController.progressDownload.value,
                        center: CommonText(
                          text: "${(productController.progressDownload.value * 100).toInt()}%",
                          fontSize: 11,
                        ),
                        progressColor: AppColor.primaryColor,
                      )
                    : InkWell(
                        onTap: () {
                          productController.downloadProductList[index].load.value = true;
                          productController.downloadFile(
                              productController.downloadProductList[index].productpdfUrl, index);
                          // final taskId = await FlutterDownloader.enqueue(
                          //   url: productController.downloadProductList[index].pricepdfUrl ?? "",
                          //   savedDir: "/storage/emulated/0/Download",
                          //   showNotification: true,
                          //   saveInPublicStorage: true,
                          //   openFileFromNotification: true,
                          // );
                          // print(taskId);
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
