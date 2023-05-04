import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ishwarpharma/api/service_locator.dart';
import 'package:ishwarpharma/api/services/product_service.dart';
import 'package:ishwarpharma/model/cart_model.dart';
import 'package:ishwarpharma/model/history_model.dart';
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
  TextEditingController firm = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController moNo = TextEditingController();

  Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await InternetConnectionChecker().hasConnection) {
        return true;
      } else {
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await InternetConnectionChecker().hasConnection) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

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
  TextEditingController remarkCon = TextEditingController();
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
          if (element.brand?.toLowerCase().contains(e.toLowerCase()) ??
                  false /*||
                  (element.brand?.toLowerCase().contains(e.toLowerCase()) ?? false) ||
                  (element.content?.toLowerCase().contains(e.toLowerCase()) ?? false)*/
              ) {
            searchList.add(element);
          } else if (element.company?.toLowerCase().contains(e.toLowerCase()) ?? false) {
            searchList.add(element);
          } else if (element.content?.toLowerCase().contains(e.toLowerCase()) ?? false) {
            searchList.add(element);
          }
        }
      }
    } else {
      for (var element in productList) {
        if (element.brand?.toLowerCase().contains(search.text.toLowerCase()) ??
                false /*||
                (element.brand?.toLowerCase().contains(search.text.toLowerCase()) ?? false) ||
                (element.content?.toLowerCase().contains(search.text.toLowerCase()) ?? false)*/
            ) {
          searchList.add(element);
        } else if (element.company?.toLowerCase().contains(search.text.toLowerCase()) ??
                false /*||
                (element.brand?.toLowerCase().contains(search.text.toLowerCase()) ?? false) ||
                (element.content?.toLowerCase().contains(search.text.toLowerCase()) ?? false)*/
            ) {
          searchList.add(element);
        } else if (element.content?.toLowerCase().contains(search.text.toLowerCase()) ??
                false /*||
                (element.brand?.toLowerCase().contains(search.text.toLowerCase()) ?? false) ||
                (element.content?.toLowerCase().contains(search.text.toLowerCase()) ?? false)*/
            ) {
          searchList.add(element);
        }
      }
    }
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  RxBool isCartLoading = true.obs;
  Rx<CartModel> cartModel = CartModel().obs;
  RxList<CartData> cartList = <CartData>[].obs;
  getCart() async {
    try {
      isCartLoading.value = true;
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Map<String, dynamic> params = {"device_id": androidInfo.id};
      final resp = await productService.getCart(params);
      if (resp != null) {
        cartModel.value = resp;
        if (cartModel.value.success ?? false) {
          cartList.value = cartModel.value.data ?? [];
          isCartLoading.value = false;
        } else {
          Get.snackbar("Error", cartModel.value.message ?? "");
          isCartLoading.value = false;
        }
      } else {
        isCartLoading.value = false;
      }
    } catch (e) {
      isCartLoading.value = false;
    }
  }

  RxBool deleteProductLoading = false.obs;

  deleteProduct(int? id, int? index) async {
    try {
      deleteProductLoading.value = true;
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      final resp = await productService.deleteProduct(androidInfo.id, id.toString());
      if (resp != null) {
        if (resp['success'] ?? false) {
          cartList.removeAt(index ?? 0);
          return deleteProductLoading.value = false;
        } else {
          Get.snackbar("Error", cartModel.value.message ?? "");
          deleteProductLoading.value = false;
        }
      }
    } catch (e) {
      deleteProductLoading.value = false;
    }
  }

  RxBool orderPlaceLoading = false.obs;
  orderPlace() async {
    try {
      orderPlaceLoading.value = true;
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      final resp = await productService.orderPlace(
        deviceId: androidInfo.id,
        email: email.text,
        mobileNo: moNo.text,
        firmName: firm.text,
        place: place.text,
      );
      if (resp != null) {
        if (resp['success'] ?? false) {
          Get.back();
          orderPlaceLoading.value = false;
          email.clear();
          firm.clear();
          place.clear();
          moNo.clear();
          getCart();
        } else {
          Get.snackbar("Error", cartModel.value.message ?? "");
          orderPlaceLoading.value = false;
        }
      }
    } catch (e) {
      orderPlaceLoading.value = false;
    }
  }

  RxBool isHistoryLoading = true.obs;
  Rx<HistoryModel> historyModel = HistoryModel().obs;
  RxList<HistoryData> historyList = <HistoryData>[].obs;
  getHistory() async {
    try {
      isHistoryLoading.value = true;
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final resp = await productService.getHistory(androidInfo.id);
      if (resp != null) {
        historyModel.value = resp;
        if (historyModel.value.success ?? false) {
          historyList.value = historyModel.value.data ?? [];
          isHistoryLoading.value = false;
        } else {
          Get.snackbar("Error", historyModel.value.message ?? "");
          isHistoryLoading.value = false;
        }
      } else {
        isHistoryLoading.value = false;
      }
    } catch (e) {
      isHistoryLoading.value = false;
    }
  }

  RxBool addCartLoading = false.obs;
  addCart({
    int? product_id,
    String? brand_name,
    String? company,
    String? pack,
    String? content,
    String? rate,
    String? scheme,
    String? mrp,
    int? qty,
    String? remark,
    String? caseData,
  }) async {
    try {
      addCartLoading.value = true;
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final resp = await productService.addCart(
        brand_name: brand_name,
        caseData: caseData,
        company: company,
        content: content,
        deviceId: androidInfo.id,
        mrp: mrp,
        pack: pack,
        product_id: product_id,
        qty: qty,
        rate: rate,
        remark: remark,
        scheme: scheme,
      );
      if (resp != null) {
        cartModel.value = resp;
        if (cartModel.value.success ?? false) {
          addCartLoading.value = false;
          quantity.value = 0;
          remarkCon.clear();
          Get.back();
          Get.snackbar("Success", cartModel.value.message ?? "");
        } else {
          Get.snackbar("Error", cartModel.value.message ?? "");
          addCartLoading.value = false;
        }
      } else {
        addCartLoading.value = false;
      }
    } catch (e) {
      addCartLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCart();
    getProduct();
  }
}
