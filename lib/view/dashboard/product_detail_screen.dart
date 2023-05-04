import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/common_widget/common_button.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/common_textfield.dart';
import 'package:ishwarpharma/view/common_widget/product_card_column.dart';

class ProductDetailScreen extends StatefulWidget {
  int? id;
  ProductDetailScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final productController = Get.find<ProductController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productController.productDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        elevation: 0,
        title: const CommonText(
          text: "Product Detail",
          color: AppColor.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(10.0),
          child: productController.productDetailLoad.value
              ? ProgressView()
              : Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: CommonText(
                                text:
                                    "${productController.productDetailModel.value.data?.brand ?? ""} ${productController.productDetailModel.value.data?.pack ?? ""}",
                                fontSize: 16,
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const Divider(
                            color: AppColor.primaryColor,
                            height: 25,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProductCardColumn(
                                  title: "Company",
                                  subTitle: productController.productDetailModel.value.data?.company ?? "",
                                  alignment: CrossAxisAlignment.center,
                                ),
                                const VerticalDivider(
                                  color: AppColor.primaryColor,
                                ),
                                ProductCardColumn(
                                  title: "Pack",
                                  subTitle: productController.productDetailModel.value.data?.pack ?? "",
                                  alignment: CrossAxisAlignment.center,
                                ),
                                const VerticalDivider(
                                  color: AppColor.primaryColor,
                                ),
                                ProductCardColumn(
                                  title: "Type",
                                  subTitle: productController.productDetailModel.value.data?.type ?? "",
                                  alignment: CrossAxisAlignment.center,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: AppColor.primaryColor,
                            height: 25,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProductCardColumn(
                                  title: "Rate",
                                  subTitle: productController.productDetailModel.value.data?.rate ?? "0",
                                  alignment: CrossAxisAlignment.center,
                                ),
                                const VerticalDivider(color: AppColor.primaryColor),
                                ProductCardColumn(
                                  title: "MRP",
                                  subTitle: productController.productDetailModel.value.data?.mrp ?? "0",
                                  alignment: CrossAxisAlignment.center,
                                ),
                                const VerticalDivider(color: AppColor.primaryColor),
                                ProductCardColumn(
                                  title: "Free Scheme",
                                  subTitle: productController.productDetailModel.value.data?.free_scheme == ""
                                      ? "0"
                                      : productController.productDetailModel.value.data?.free_scheme ?? "0",
                                  alignment: CrossAxisAlignment.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          CommonTextField(
                            hintText: "Order case",
                            labelText: "Order case",
                            controller: productController.caseDetail,
                          ),
                          const SizedBox(height: 15),
                          CommonTextField(
                            hintText: "Remark",
                            labelText: "Remark",
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                productController.removeQuantity();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: AppColor.primaryColor),
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Obx(
                              () => CommonText(
                                text: productController.quantity.value.toString(),
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                productController.addQuantity();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: AppColor.primaryColor),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CommonButton(
                            btnText: "Add to cart",
                            fontSize: 20,
                            onTap: () {},
                          ),
                        ),
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
