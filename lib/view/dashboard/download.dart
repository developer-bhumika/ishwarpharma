import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadScreen extends StatefulWidget {
  DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> with TickerProviderStateMixin {
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
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    print(statuses[Permission.storage]);
    if (await Permission.storage.request().isDenied) {
      // Either the permission was already granted before or the user just granted it.
    }
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    controller: tabController,
                    tabs: [
                      Tab(
                        text: "Product Catalog",
                      ),
                      Tab(
                        text: "Price List",
                      ),
                    ],
                    labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                    indicatorColor: AppColor.primaryColor,
                    labelColor: AppColor.primaryColor,
                    unselectedLabelColor: AppColor.textColor,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.all(15),
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
                                          child: Icon(Icons.download, color: AppColor.primaryColor),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(15),
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
                                            productController.downloadFile(
                                                productController.downloadPriceList[index].pricepdfUrl, index);
                                          },
                                          child: Icon(Icons.download, color: AppColor.primaryColor),
                                        ),
                                ),
                              ],
                            ),
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
