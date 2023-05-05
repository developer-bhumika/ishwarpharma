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
                                text: "${widget.brand_name} ${widget.pack}",
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
                          CommonText(
                            text: widget.content,
                            fontSize: 14,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProductCardColumn(
                                  title: "Company",
                                  subTitle: widget.company,
                                  alignment: CrossAxisAlignment.center,
                                ),
                                const VerticalDivider(
                                  color: AppColor.primaryColor,
                                ),
                                ProductCardColumn(
                                  title: "Pack",
                                  subTitle: widget.pack,
                                  alignment: CrossAxisAlignment.center,
                                ),
                                const VerticalDivider(
                                  color: AppColor.primaryColor,
                                ),
                                ProductCardColumn(
                                  title: widget.view ?? false ? "Quantity" : "Type",
                                  subTitle: widget.type,
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
                                  subTitle: widget.rate,
                                  alignment: CrossAxisAlignment.center,
                                ),
                                const VerticalDivider(color: AppColor.primaryColor),
                                ProductCardColumn(
                                  title: "MRP",
                                  subTitle: widget.mrp,
                                  alignment: CrossAxisAlignment.center,
                                ),
                                const VerticalDivider(color: AppColor.primaryColor),
                                ProductCardColumn(
                                  title: "Free Scheme",
                                  subTitle: widget.scheme == "" ? "0" : widget.scheme,
                                  alignment: CrossAxisAlignment.center,
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
                                  hintText: "Remark",
                                  labelText: "Remark",
                                  controller: productController.remarkCon,
                                )
                        ],
                      ),
                    ),
                    widget.view ?? false
                        ? SizedBox()
                        : Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColor.primaryColor),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        productController.removeQuantity();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
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
                                    ),
                                    const SizedBox(width: 12),
                                    Obx(
                                      () => CommonText(
                                        text: productController.quantity.value.toString(),
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    InkWell(
                                      onTap: () {
                                        productController.addQuantity();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
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
    );
  }
}
