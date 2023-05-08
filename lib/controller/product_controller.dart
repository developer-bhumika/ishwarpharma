import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ishwarpharma/api/service_locator.dart';
import 'package:ishwarpharma/api/services/product_service.dart';
import 'package:ishwarpharma/model/cart_model.dart';
import 'package:ishwarpharma/model/company_model.dart';
import 'package:ishwarpharma/model/history_model.dart';
import 'package:ishwarpharma/model/product_detail_model.dart';
import 'package:ishwarpharma/model/product_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
  RxBool reLoad = false.obs;

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
            Get.snackbar("Error", productModel.value.message ?? "",
                messageText: Text(
                  productModel.value.message ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.green.shade900,
                  ),
                ),
                backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
                colorText: Colors.green.shade900);
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
  RxInt quantity = 1.obs;
  RxBool productDetailLoad = false.obs;

  addQuantity() {
    quantity.value++;
  }

  removeQuantity() {
    if (quantity > 1) {
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
          Get.snackbar("Error", productDetailModel.value.message ?? "",
              messageText: Text(
                productDetailModel.value.message ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.green.shade900,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
              colorText: Colors.green.shade900);
          productDetailLoad.value = false;
        }
      } else {
        productDetailLoad.value = false;
      }
    } catch (e) {
      productDetailLoad.value = false;
    }
  }

  Rx<CompanyModel> companyModel = CompanyModel().obs;
  RxList<CompanyData> companyList = <CompanyData>[].obs;
  RxBool companyLoad = false.obs;

  getCompany() async {
    companyLoad.value = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('company') != null) {
      final data = preferences.getString('company');
      companyModel.value = CompanyModel.fromJson(jsonDecode(data ?? ""));
      companyList.value = companyModel.value.data ?? [];
      if (companyList.isNotEmpty) {
        companyLoad.value = false;
      } else {
        companyLoad.value = false;
      }
    } else {
      try {
        companyLoad.value = true;
        final resp = await productService.getCompany();
        if (resp != null) {
          companyModel.value = resp;
          if (companyModel.value.success ?? false) {
            companyList.value = companyModel.value.data ?? [];
            if (companyList.isNotEmpty) {
              var jsonRes = jsonDecode(jsonEncode(companyModel));
              await preferences.setString('company', json.encode(jsonRes));
            }
            companyLoad.value = false;
          } else {
            Get.snackbar("Error", companyModel.value.message ?? "",
                messageText: Text(
                  companyModel.value.message ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.green.shade900,
                  ),
                ),
                backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
                colorText: Colors.green.shade900);
            companyLoad.value = false;
          }
        } else {
          companyLoad.value = false;
        }
      } catch (e) {
        companyLoad.value = false;
      }
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
          Get.snackbar(
            "Error",
            cartModel.value.message ?? "",
            messageText: Text(
              cartModel.value.message ?? "",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.green.shade900),
            ),
            backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
            colorText: Colors.green.shade900,
          );
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
  RxInt selectedItem = 1.obs;

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
          Get.snackbar("Error", cartModel.value.message ?? "",
              messageText: Text(
                cartModel.value.message ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.green.shade900,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
              colorText: Colors.green.shade900);
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
          Get.snackbar("Error", cartModel.value.message ?? "",
              messageText: Text(
                cartModel.value.message ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.green.shade900,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
              colorText: Colors.green.shade900);
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('history') != null) {
      isHistoryLoading.value = true;
      final data = preferences.getString('history');
      historyModel.value = HistoryModel.fromJson(jsonDecode(data ?? ""));
      historyList.value = historyModel.value.data ?? [];
      if (historyList.isNotEmpty) {
        isHistoryLoading.value = false;
      }
    } else {
      try {
        isHistoryLoading.value = true;
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        final resp = await productService.getHistory(androidInfo.id);
        if (resp != null) {
          historyModel.value = resp;
          if (historyModel.value.success ?? false) {
            historyList.value = historyModel.value.data ?? [];
            if (historyList.isNotEmpty) {
              var jsonRes = jsonDecode(jsonEncode(historyModel));
              await preferences.setString('history', json.encode(jsonRes));
            }
            isHistoryLoading.value = false;
          } else {
            Get.snackbar("Error", historyModel.value.message ?? "",
                messageText: Text(
                  historyModel.value.message ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.green.shade900,
                  ),
                ),
                backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
                colorText: Colors.green.shade900);
            isHistoryLoading.value = false;
          }
        } else {
          isHistoryLoading.value = false;
        }
      } catch (e) {
        isHistoryLoading.value = false;
      }
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
          quantity.value = 1;
          remarkCon.clear();
          getCart();
          Get.back();
          Get.snackbar("Success", cartModel.value.message ?? "",
              messageText: Text(
                cartModel.value.message ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.green.shade900,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
              colorText: Colors.green.shade900);
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

  downloadPdf() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          ); // Center
        }));

    final output = await getTemporaryDirectory();
    final file = File("/storage/emulated/0/Download/${DateTime.now()}}.pdf");
    await file.writeAsBytes(await pdf.save());
  }

  @override
  void onInit() {
    super.onInit();
    getCompany();
    getCart();
    getProduct();
  }
}
