import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/model/history_model.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class HistoryCard extends StatelessWidget {
  List<Products>? products;
  HistoryCard({Key? key, this.products}) : super(key: key);
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.primaryColor),
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.secondaryColor.withOpacity(0.2),
              AppColor.primaryColor.withOpacity(0.2),
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: products
                        ?.map(
                          (e) => Row(
                            children: [
                              CommonText(text: "${e.brand_name} - ", fontWeight: FontWeight.w500),
                              CommonText(text: e.qty ?? "", fontWeight: FontWeight.w500)
                            ],
                          ),
                        )
                        .toList() ??
                    [],
              ),
            ),
          ],
        ));
  }
}
