import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/product_card.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({Key? key}) : super(key: key);

  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            cursorColor: AppColor.primaryColor,
            onChanged: (v) {
              if (v.isEmpty) {
                productController.searchList.clear();
              } else {
                productController.searchProduct(v);
              }
            },
            controller: productController.search,
            decoration: const InputDecoration(
              hintText: "Search medicine",
              prefixIcon: Icon(Icons.search, size: 25, color: AppColor.primaryColor),
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              isDense: true,
            ),
          ),
        ),
        Obx(() => productController.isLoading.value
            ? Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(color: AppColor.primaryColor),
                    ),
                  ],
                ),
              )
            : productController.productList.isEmpty
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CommonText(
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w700,
                          color: AppColor.primaryColor,
                          text: "No Products Available",
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: productController.searchList.isNotEmpty
                        ? ListView.separated(
                            itemCount: productController.searchList.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, index) => ProductCard(
                              title:
                                  "${productController.searchList[index].brand ?? ""} ${productController.searchList[index].pack ?? ""}",
                              company: productController.searchList[index].company ?? "",
                              rate: productController.searchList[index].rate ?? "",
                              mrp: productController.searchList[index].mrp ?? "",
                              free: productController.searchList[index].free_scheme ?? "",
                              subTitle: productController.searchList[index].content ?? "",
                              searchTextList: productController.searchTextList,
                              searchText: productController.search.text,
                            ),
                          )
                        : ListView.separated(
                            itemCount: productController.productList.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, index) => ProductCard(
                              title:
                                  "${productController.productList[index].brand ?? ""} ${productController.productList[index].pack ?? ""}",
                              company: productController.productList[index].company ?? "",
                              rate: productController.productList[index].rate ?? "",
                              mrp: productController.productList[index].mrp ?? "",
                              searchText: productController.search.text,
                              searchTextList: productController.searchTextList,
                              free: productController.productList[index].free_scheme ?? "",
                              subTitle: productController.productList[index].content ?? "",
                            ),
                          ),
                  ))
      ],
    );
  }
}
