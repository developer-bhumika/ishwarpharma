import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class DownloadScreen extends StatefulWidget {
  DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    productController.getDownloads();
    productController.getDownloads(pass: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColor.primaryColor, AppColor.secondaryColor],
            ),
          ),
        ),
        centerTitle: true,
        title: CommonText(
          text: "Download",
          color: AppColor.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Obx(
        () => productController.downloadsProductLoad.value && productController.downloadsPriceLoad.value
            ? ProgressView()
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
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
                            InkWell(
                              onTap: () async {
                                final taskId = await FlutterDownloader.enqueue(
                                  url: productController.downloadProductList[index].pricepdfUrl ?? "",
                                  savedDir: "/storage/emulated/0/Download",
                                  showNotification: true,
                                  saveInPublicStorage: true,
                                  openFileFromNotification: true,
                                );
                                print(taskId);
                              },
                              child: Icon(Icons.download, color: AppColor.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
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
                            InkWell(
                              onTap: () {
                                productController.downloadFile(index);
                              },
                              child: Icon(Icons.download, color: AppColor.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
