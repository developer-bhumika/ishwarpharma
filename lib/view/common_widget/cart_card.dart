import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class CartCard extends StatelessWidget {
  bool? view;
  String? brand;
  String? qty;
  int? index;
  String? company;
  String? content;
  String? price;
  CartCard({Key? key, this.view, this.brand, this.qty, this.index, this.company, this.content, this.price})
      : super(key: key);
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
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(text: brand ?? "", fontWeight: FontWeight.w600),
              const SizedBox(height: 5),
              CommonText(text: company ?? "", fontWeight: FontWeight.w500),
              const SizedBox(height: 5),
              CommonText(text: content ?? ""),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    text: "${price ?? " "} ",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryColor,
                  ),
                  CommonText(
                    text: "${qty ?? " "} Unit",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryColor,
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              productController.selectedItem.value = index!;
              productController.deleteProduct(productController.cartList[index ?? 0].id, index);
            },
            child: Obx(
              () => productController.deleteProductLoading.value && productController.selectedItem.value == index
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: ProgressView(),
                    )
                  : Icon(Icons.delete, color: AppColor.primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
