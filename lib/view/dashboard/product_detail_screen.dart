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
  String? brand_name;
  String? company;
  String? pack;
  String? content;
  String? rate;
  String? scheme;
  String? mrp;
  String? caseData;
  String? type;
  bool? view;
  ProductDetailScreen(
      {Key? key,
      this.id,
      this.caseData,
      this.company,
      this.content,
      this.mrp,
      this.pack,
      this.rate,
      this.brand_name,
      this.type,
      this.scheme,
      this.view})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final productController = Get.find<ProductController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.view == null) {
      productController.caseDetail.text = widget.caseData!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Obx(
        () => Column(
          children: [
            Container(
              height: 94,
              width: Get.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColor.primaryColor, AppColor.secondaryColor],
                ),
              ),
              child: SafeArea(
                  child: Row(
                children: [
                  SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.white,
                    ),
                  ),
                  SizedBox(width: 5),
                  CommonText(
                    text: "Product Details",
                    color: AppColor.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )
                ],
              )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: productController.productDetailLoad.value
                    ? ProgressView()
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: AppColor.teal,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Center(
                                      child: CommonText(
                                        text: "${widget.brand_name} ${widget.pack}",
                                        fontSize: 16,
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      border: Border.all(
                                        color: AppColor.borderColorProduct,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: CommonText(
                                      text: widget.content,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      textHeight: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      border: Border.all(
                                        color: AppColor.borderColorProduct,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    text: "Company",
                                                    color: AppColor.greyGreen,
                                                    fontSize: 11,
                                                  ),
                                                  SizedBox(height: 5),
                                                  CommonText(
                                                    text: widget.company,
                                                    color: AppColor.textColor,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    text: "Pack",
                                                    color: AppColor.greyGreen,
                                                    fontSize: 12,
                                                  ),
                                                  SizedBox(height: 5),
                                                  CommonText(
                                                    text: widget.pack,
                                                    color: AppColor.textColor,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    text: "Type",
                                                    color: AppColor.greyGreen,
                                                    fontSize: 11,
                                                  ),
                                                  SizedBox(height: 5),
                                                  CommonText(
                                                    text: widget.type,
                                                    color: AppColor.textColor,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    text: "Rate",
                                                    color: AppColor.greyGreen,
                                                    fontSize: 12,
                                                  ),
                                                  SizedBox(height: 5),
                                                  CommonText(
                                                    text: widget.rate,
                                                    color: AppColor.textColor,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    text: "MRP",
                                                    color: AppColor.greyGreen,
                                                    fontSize: 11,
                                                  ),
                                                  SizedBox(height: 5),
                                                  CommonText(
                                                    text: widget.mrp,
                                                    color: AppColor.textColor,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CommonText(
                                                    text: "Free Scheme",
                                                    color: AppColor.greyGreen,
                                                    fontSize: 12,
                                                  ),
                                                  SizedBox(height: 5),
                                                  CommonText(
                                                    text: widget.scheme == "" ? "0" : widget.scheme,
                                                    color: AppColor.textColor,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  widget.view ?? false
                                      ? SizedBox()
                                      : CommonTextField(
                                          hintText: "Order case",
                                          labelText: "Order case",
                                          controller: productController.caseDetail,
                                        ),
                                  widget.view ?? false ? SizedBox() : const SizedBox(height: 15),
                                  widget.view ?? false
                                      ? SizedBox()
                                      : CommonTextField(
                                          hintText: "Your Remark",
                                          labelText: "Remark",
                                          controller: productController.remarkCon,
                                        )
                                ],
                              ),
                            ),
                          ),
                          widget.view ?? false
                              ? SizedBox()
                              : Row(
                                  children: [
                                    Container(
                                      height: 52,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppColor.primaryColor),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              productController.addQuantity();
                                            },
                                            child: Container(
                                              height: double.infinity,
                                              width: 40,
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
                                          const SizedBox(width: 15),
                                          Obx(
                                            () => CommonText(
                                              text: productController.quantity.value.toString(),
                                              color: Colors.black,
                                              fontSize: 17,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          InkWell(
                                            onTap: () {
                                              productController.removeQuantity();
                                            },
                                            child: Container(
                                              height: double.infinity,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: AppColor.primaryColor.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child: const Icon(
                                                Icons.remove,
                                                color: AppColor.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Obx(
                                        () => CommonButton(
                                          btnText: "Add to cart",
                                          fontSize: 20,
                                          load: productController.addCartLoading.value,
                                          onTap: () async {
                                            if (productController.quantity.value > 0) {
                                              if (await productController.isInternet()) {
                                                productController.addCart(
                                                  scheme: widget.scheme == "" ? "0" : widget.scheme,
                                                  remark: productController.remarkCon.text,
                                                  rate: widget.rate,
                                                  qty: productController.quantity.value,
                                                  product_id: widget.id,
                                                  pack: widget.pack,
                                                  mrp: widget.mrp,
                                                  content: widget.content,
                                                  brand_name: widget.brand_name,
                                                  company: widget.company,
                                                  caseData: widget.caseData,
                                                );
                                              } else {
                                                Get.snackbar("Network", "Check your internet connection",
                                                    messageText: Text(
                                                      "Check your internet connection",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 13,
                                                        color: Colors.green.shade900,
                                                      ),
                                                    ),
                                                    backgroundColor: Color(0xff81B29A).withOpacity(0.9),
                                                    colorText: Colors.green.shade900);
                                              }
                                            } else {
                                              Get.snackbar("Required", "Minimum 1 quantity required",
                                                  messageText: Text(
                                                    "Minimum 1 quantity required",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 13,
                                                      color: Colors.green.shade900,
                                                    ),
                                                  ),
                                                  backgroundColor: Color(0xff81B29A).withOpacity(0.9),
                                                  colorText: Colors.green.shade900);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
