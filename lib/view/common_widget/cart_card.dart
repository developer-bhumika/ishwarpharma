import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class CartCard extends StatelessWidget {
  bool? view;
  bool? edit;
  bool? load;
  String? brand;
  String? qty;
  int? index;
  String? company;
  String? content;
  String? price;
  void Function()? editOnTap;
  void Function()? saveOnTap;
  void Function()? addOnTap;
  void Function()? minusOnTap;
  CartCard({
    Key? key,
    this.view,
    this.edit,
    this.load,
    this.brand,
    this.qty,
    this.index,
    this.company,
    this.content,
    this.price,
    this.editOnTap,
    this.saveOnTap,
    this.addOnTap,
    this.minusOnTap,
  }) : super(key: key);
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
                children: [
                  CommonText(
                    text: "${price ?? " "} ",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryColor,
                  ),
                  const Spacer(),
                  edit ?? false
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColor.primaryColor), borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: minusOnTap,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryColor.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: const Icon(Icons.remove, color: AppColor.primaryColor),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              CommonText(
                                text: qty ?? "0",
                                color: Colors.black,
                                fontSize: 17,
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: addOnTap,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryColor.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : CommonText(
                          text: "${qty ?? " "} Unit",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryColor,
                        ),
                  const SizedBox(width: 5),
                  edit ?? false
                      ? load ?? false
                          ? SizedBox(width: 25, height: 25, child: ProgressView())
                          : InkWell(
                              onTap: saveOnTap,
                              child: const Icon(Icons.save, size: 35, color: AppColor.primaryColor),
                            )
                      : InkWell(
                          onTap: editOnTap,
                          child: const Icon(Icons.edit, size: 18, color: AppColor.primaryColor),
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
                  : const Icon(Icons.delete, color: AppColor.primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
