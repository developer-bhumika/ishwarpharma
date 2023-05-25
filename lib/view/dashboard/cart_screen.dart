// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/cart_card.dart';
import 'package:ishwarpharma/view/common_widget/common_button.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/common_textfield.dart';
import 'package:ishwarpharma/view/dashboard/product_detail_screen.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final productController = Get.find<ProductController>();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    productController.getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColor.primaryColor, AppColor.secondaryColor],
            ),
          ),
        ),
        centerTitle: true,
        title: CommonText(
          text: "Cart",
          color: AppColor.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(
          () => productController.isCartLoading.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(color: AppColor.primaryColor),
                    ),
                  ],
                )
              : productController.cartList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(width: 150, height: 150, AppImage.emptyCart),
                        const CommonText(
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w700,
                          color: AppColor.primaryColor,
                          text: "Your Cart is Empty",
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: productController.cartList.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Get.to(ProductDetailScreen(
                                  id: productController.cartList[index].id,
                                  brand_name: productController.cartList[index].brand_name ?? "",
                                  content: productController.cartList[index].content ?? "",
                                  type: productController.cartList[index].qty ?? "",
                                  company: productController.cartList[index].company ?? "",
                                  rate: productController.cartList[index].rate ?? "0",
                                  scheme: productController.cartList[index].scheme ?? "0",
                                  mrp: productController.cartList[index].mrp ?? "0",
                                  pack: productController.cartList[index].pack ?? "0",
                                  view: true,
                                ));
                              },
                              child: Obx(
                                () => CartCard(
                                  brand: productController.cartList[index].brand_name ?? "",
                                  qty: productController.cartList[index].qty ?? "",
                                  index: index,
                                  company: productController.cartList[index].company ?? "",
                                  content: productController.cartList[index].content ?? "",
                                  price: productController.cartList[index].mrp ?? "0",
                                  edit: productController.cartList[index].edit.value,
                                  load: productController.cartList[index].load.value,
                                  saveOnTap: () async {
                                    productController.cartList[index].load.value = true;
                                    bool? res = await productController.editCart(
                                        productController.cartList[index].id, productController.cartList[index].qty);
                                    if (res != null && res) {
                                      productController.cartList[index].load.value = false;
                                      productController.cartList[index].edit.value = false;
                                    }
                                  },
                                  addOnTap: () {
                                    int qty = int.parse(productController.cartList[index].qty ?? "");
                                    setState(() => qty++);
                                    productController.cartList[index].qty = qty.toString();
                                  },
                                  minusOnTap: () {
                                    int qty = int.parse(productController.cartList[index].qty ?? "");

                                    if (qty > 1) {
                                      setState(() => qty--);
                                      productController.cartList[index].qty = qty.toString();
                                    }
                                  },
                                  editOnTap: () => productController.cartList[index].edit.value = true,
                                ),
                              ),
                            ),
                          ),
                        ),
                        productController.cartList.isEmpty
                            ? const SizedBox()
                            : CommonButton(
                                onTap: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Center(
                                        child: CommonText(
                                          text: "PlaceOrder",
                                          color: AppColor.primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      content: FormBuilder(
                                        key: _formKey,
                                        child: SingleChildScrollView(
                                          physics: const BouncingScrollPhysics(),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CommonTextField(
                                                labelText: "Firm Name",
                                                hintText: "Firm Name",
                                                isDense: true,
                                                controller: productController.firm,
                                                validator: FormBuilderValidators.required(),
                                              ),
                                              const SizedBox(height: 10),
                                              CommonTextField(
                                                labelText: "Place",
                                                hintText: "Place",
                                                isDense: true,
                                                controller: productController.place,
                                                validator: FormBuilderValidators.required(),
                                              ),
                                              const SizedBox(height: 10),
                                              CommonTextField(
                                                labelText: "Email",
                                                hintText: "Email",
                                                isDense: true,
                                                controller: productController.email,
                                                validator: FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(),
                                                  FormBuilderValidators.email(),
                                                ]),
                                              ),
                                              const SizedBox(height: 10),
                                              CommonTextField(
                                                labelText: "Mobile Number",
                                                hintText: "Mobile Number",
                                                isDense: true,
                                                keyBoardType: TextInputType.number,
                                                controller: productController.moNo,
                                                validator: FormBuilderValidators.compose([
                                                  FormBuilderValidators.required(),
                                                  FormBuilderValidators.equalLength(10,
                                                      errorText: "Please enter 10 digit mobile number"),
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CommonButton(
                                                height: 40,
                                                onTap: () {
                                                  productController.email.clear();
                                                  productController.firm.clear();
                                                  productController.place.clear();
                                                  productController.moNo.clear();
                                                  Get.back();
                                                },
                                                color: AppColor.primaryColor,
                                                btnText: "Cancel",
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Obx(
                                                () => CommonButton(
                                                  sizeBoxHeight: 20,
                                                  sizeBoxWidth: 20,
                                                  load: productController.orderPlaceLoading.value,
                                                  height: 40,
                                                  onTap: () {
                                                    if (_formKey.currentState!.validate()) {
                                                      productController.orderPlace();
                                                    }
                                                  },
                                                  color: AppColor.primaryColor,
                                                  btnText: "Confirm",
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                color: AppColor.primaryColor,
                                btnText: "Place Order")
                      ],
                    ),
        ),
      ),
    );
  }
}
