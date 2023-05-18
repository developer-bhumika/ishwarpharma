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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Obx(
            () => productController.downloadsProductLoad.value
                ? ProgressView()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: productController.downloadProductList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.primaryColor),
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColor.secondaryColor.withOpacity(0.2), AppColor.primaryColor.withOpacity(0.2)],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonText(
                                text: productController.downloadProductList[index].name ?? "",
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          const CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColor.primaryColor,
                            child: Icon(Icons.download, color: AppColor.white),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => productController.downloadsPriceLoad.value
                ? ProgressView()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: productController.downloadPriceList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.primaryColor),
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColor.secondaryColor.withOpacity(0.2), AppColor.primaryColor.withOpacity(0.2)],
                        ),
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
                            onTap: () async {
                              productController.downloadPriceList[index].pricepdfUrl;
                              try {
                                final taskId = await FlutterDownloader.enqueue(
                                  url: productController.downloadPriceList[index].pricepdfUrl ?? "",
                                  savedDir: "/storage/emulated/0/Download",
                                  showNotification: true, // show download progress in status bar (for Android)
                                  openFileFromNotification:
                                      true, // click on notification to open downloaded file (for Android)
                                );
                                print(taskId);
                              } on Exception catch (e) {
                                print(e);
                              }
                            },
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundColor: AppColor.primaryColor,
                              child: Icon(Icons.download, color: AppColor.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
