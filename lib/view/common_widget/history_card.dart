import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/model/history_model.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/dashboard/product_detail_screen.dart';

class HistoryCard extends StatelessWidget {
  List<Products>? products;
  HistoryCard({Key? key, this.products}) : super(key: key);
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.borderColorProduct),
          borderRadius: BorderRadius.circular(6),
          color: AppColor.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: products
                ?.map(
                  (e) => InkWell(
                    onTap: () {
                      Get.to(ProductDetailScreen(
                        id: int.parse(e.product_id.toString()),
                        brand_name: e.brand_name ?? "",
                        content: e.content ?? "",
                        type: e.qty ?? "",
                        company: e.company ?? "",
                        rate: e.rate ?? "0",
                        scheme: e.scheme ?? "0",
                        mrp: e.mrp ?? "0",
                        pack: e.pack ?? "0",
                        view: true,
                      ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(text: e.brand_name, fontWeight: FontWeight.w600, color: AppColor.primaryColor),
                        const SizedBox(height: 5),
                        CommonText(text: e.company, fontWeight: FontWeight.w500),
                        const SizedBox(height: 5),
                        CommonText(text: e.content),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              text: e.mrp,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primaryColor,
                            ),
                            CommonText(
                              text: "${e.qty} Unit",
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primaryColor,
                            ),
                          ],
                        ),
                        e == products?.last
                            ? const SizedBox()
                            : const Divider(
                                height: 25,
                                color: AppColor.primaryColor,
                              )
                      ],
                    ),
                  ),
                )
                .toList() ??
            [],
      ),
    );
  }
}
