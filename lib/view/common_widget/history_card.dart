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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: products
                  ?.map(
                    (e) => InkWell(
                      onTap: () {
                        productController.downloadPdf();
                        // Get.to(ProductDetailScreen(
                        //   id: int.parse(e.product_id.toString()),
                        //   brand_name: e.brand_name ?? "",
                        //   content: e.content ?? "",
                        //   type: e.qty ?? "",
                        //   company: e.company ?? "",
                        //   rate: e.rate ?? "0",
                        //   scheme: e.scheme ?? "0",
                        //   mrp: e.mrp ?? "0",
                        //   pack: e.pack ?? "0",
                        //   view: true,
                        // ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(text: e.brand_name, fontWeight: FontWeight.w600),
                          SizedBox(height: 5),
                          CommonText(text: e.company, fontWeight: FontWeight.w500),
                          SizedBox(height: 5),
                          CommonText(text: e.content),
                          SizedBox(height: 5),
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
                              ? SizedBox()
                              : Divider(
                                  height: 25,
                                  color: AppColor.primaryColor,
                                )
                        ],
                      ),
                    ),
                  )
                  .toList() ??
              [],
        ));
  }
}
