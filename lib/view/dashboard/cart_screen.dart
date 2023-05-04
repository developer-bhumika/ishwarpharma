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
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
                    children: [
                      Image.asset(width: 150, height: 150, AppImage.cart),
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
                          itemBuilder: (context, index) => CartCard(
                            brand: productController.cartList[index].brand_name ?? "",
                            qty: productController.cartList[index].qty ?? "",
                            index: index,
                          ),
                        ),
                      ),
                      CommonButton(
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
                                        validator: FormBuilderValidators.required(),
                                      ),
                                      const SizedBox(height: 10),
                                      CommonTextField(
                                        labelText: "Mobile Number",
                                        hintText: "Mobile Number",
                                        isDense: true,
                                        controller: productController.moNo,
                                        validator: FormBuilderValidators.required(),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CommonButton(
                                          height: 40,
                                          onTap: () => Get.back(),
                                          color: AppColor.primaryColor,
                                          btnText: "Cancel",
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: CommonButton(
                                          height: 40,
                                          onTap: () {
                                            if (_formKey.currentState?.validate() ?? false) {}
                                          },
                                          color: AppColor.primaryColor,
                                          btnText: "Confirm",
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          color: AppColor.primaryColor,
                          btnText: "PlaceOrder")
                    ],
                  ),
      ),
    );
  }
}
