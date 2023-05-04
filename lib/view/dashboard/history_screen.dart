import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/history_card.dart';

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
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        HistoryCard(products: productController.historyList[index].products),
                  ),
      ),
    );
  }
}
