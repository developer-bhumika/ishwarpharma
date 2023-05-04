import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/api/service_locator.dart';
import 'package:ishwarpharma/api/services/product_service.dart';
import 'package:ishwarpharma/model/product_detail_model.dart';
import 'package:ishwarpharma/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  final productService = getIt.get<ProductService>();
  RxBool isLoading = true.obs;
  RxList<ProductDataModel> productList = <ProductDataModel>[].obs;
  RxList<ProductDataModel> searchList = <ProductDataModel>[].obs;
  Rx<ProductModel> productModel = ProductModel().obs;
  RxList<ProductDataModel> productIndList = <ProductDataModel>[].obs;

  getProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getString('product') != null) {
      isLoading.value = true;
      final data = preferences.getString('product');
      productModel.value = ProductModel.fromJson(jsonDecode(data ?? ""));
      productList.value = productModel.value.data ?? [];
      if (productList.isNotEmpty) {
        productList.sort((a, b) => a.brand!.compareTo(b.brand ?? ""));
        // for (int i = 0; i < num.parse(productList.length.toString()); i++) {
        //   if (productList[i].brand![0] == "0" ||
        //       productList[i].brand![0] == "1" ||
        //       productList[i].brand![0] == "2" ||
        //       productList[i].brand![0] == "3" ||
        //       productList[i].brand![0] == "4" ||
        //       productList[i].brand![0] == "5" ||
        //       productList[i].brand![0] == "6" ||
        //       productList[i].brand![0] == "7" ||
        //       productList[i].brand![0] == "8" ||
        //       productList[i].brand![0] == "9") {
        //     productIndList.add(productList[i]);
        //   }
        // }
        // productIndList.forEach((e) {
        //   productList.remove(e);
        // });
        // print(productList[0].brand);
        isLoading.value = false;
      }
    } else {
      try {
        isLoading.value = true;
        final resp = await productService.getProduct();
        if (resp != null) {
          productModel.value = resp;
          if (productModel.value.success ?? false) {
            productList.value = productModel.value.data ?? [];
            if (productList.isNotEmpty) {
              productList.sort((a, b) => a.brand!.compareTo(b.brand ?? ""));
              var jsonRes = jsonDecode(jsonEncode(productModel));
              await preferences.setString('product', json.encode(jsonRes));
              print(preferences.getString('product'));
            }
            isLoading.value = false;
          } else {
            Get.snackbar("Error", productModel.value.message ?? "");
            isLoading.value = false;
          }
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
      }
    }
  }

  Rx<ProductDetailModel> productDetailModel = ProductDetailModel().obs;
  TextEditingController caseDetail = TextEditingController();
  RxInt quantity = 0.obs;
  RxBool productDetailLoad = false.obs;

  addQuantity() {
    quantity.value++;
  }

  removeQuantity() {
    if (quantity > 0) {
      quantity.value--;
    }
  }

  productDetail(int? id) async {
    try {
      productDetailLoad.value = true;
      final resp = await productService.productDetail(id);
      if (resp != null) {
        productDetailModel.value = resp;
        if (productDetailModel.value.success ?? false) {
          caseDetail.text = productDetailModel.value.data?.case_value ?? "0";
          productDetailLoad.value = false;
        } else {
          Get.snackbar("Error", productDetailModel.value.message ?? "");
          productDetailLoad.value = false;
        }
      } else {
        productDetailLoad.value = false;
      }
    } catch (e) {
      productDetailLoad.value = false;
    }
  }

  final search = TextEditingController();
  final RxList<String> searchTextList = <String>[].obs;
  searchProduct(String v) {
    searchList.clear();
    searchTextList.value = search.text.split(" ").toList();
    if (search.text.contains(" ")) {
      for (var e in searchTextList) {
        for (var element in productList) {
          if (element.company?.toLowerCase().contains(e.toLowerCase()) ??
              false ||
                  (element.brand?.toLowerCase().contains(e.toLowerCase()) ?? false) ||
                  (element.content?.toLowerCase().contains(e.toLowerCase()) ?? false)) {
            searchList.add(element);
          }
        }
      }
    } else {
      for (var element in productList) {
        if (element.company?.toLowerCase().contains(search.text.toLowerCase()) ??
            false ||
                (element.brand?.toLowerCase().contains(search.text.toLowerCase()) ?? false) ||
                (element.content?.toLowerCase().contains(search.text.toLowerCase()) ?? false)) {
          searchList.add(element);
        }
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProduct();
  }
}
