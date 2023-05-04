import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/cart_card.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final productController = Get.find<ProductController>();

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
              : productController.productList.isEmpty
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
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: productController.cartList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => CartCard(),
                    ),
        ));
  }
}
