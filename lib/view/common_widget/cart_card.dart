import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class CartCard extends StatelessWidget {
  bool? view;
  String? brand;
  String? qty;
  int? index;
  CartCard({Key? key, this.view, this.brand, this.qty, this.index}) : super(key: key);
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
              children: [
                CommonText(text: brand ?? "", fontWeight: FontWeight.w500),
                const SizedBox(height: 5),
                CommonText(text: qty ?? "", fontSize: 12),
              ],
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  productController.deleteProduct(productController.cartList[index ?? 0].id);
                  productController.cartList.removeAt(index ?? 0);
                },
                child: const Icon(Icons.delete, color: AppColor.primaryColor),
              )
            ],
          )
        ],
      ),
    );
  }
}
