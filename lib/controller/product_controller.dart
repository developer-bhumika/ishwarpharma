import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ishwarpharma/api/service_locator.dart';
import 'package:ishwarpharma/api/services/product_service.dart';
import 'package:ishwarpharma/model/cart_model.dart';
import 'package:ishwarpharma/model/company_model.dart';
import 'package:ishwarpharma/model/download_model.dart';
import 'package:ishwarpharma/model/history_model.dart';
import 'package:ishwarpharma/model/product_detail_model.dart';
import 'package:ishwarpharma/model/product_model.dart';
import 'package:ishwarpharma/model/slider_model.dart';
import 'package:permission_handler/permission_handler.dart';
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
  String? selectedCity;
  RxList<String> cityList = ["Surat", "Vapi", "Ahmedabad", "Vadodara"].obs;

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

  RxBool editCartLoad = false.obs;

  Future<bool?> editCart(int? id, String? qty) async {
    try {
      editCartLoad.value = true;
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      final resp = await productService.editCart(id, qty, androidInfo.id);
      if (resp != null) {
        if (resp["success"] ?? false) {
          editCartLoad.value = false;
          return true;
        } else {
          Get.snackbar("Error", resp["message"] ?? "",
              backgroundColor: const Color(0xff81B29A).withOpacity(0.9), colorText: Colors.green.shade900);
          editCartLoad.value = false;
          return true;
        }
      } else {
        editCartLoad.value = false;
      }
    } catch (e) {
      editCartLoad.value = false;
    }
    return true;
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
        isLoading.value = false;
      }
    } else {
      try {
        isLoading.value = true;
        final resp = await productService.getProduct(search.text);
        if (resp != null) {
          productModel.value = resp;
          if (productModel.value.success ?? false) {
            productList.value = productModel.value.data ?? [];
            if (productList.isNotEmpty) {
              productList.sort((a, b) => a.brand!.compareTo(b.brand ?? ""));
              var jsonRes = jsonDecode(jsonEncode(productModel));
              await preferences.setString('product', json.encode(jsonRes));
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

  Rx<SliderModel> sliderModel = SliderModel().obs;
  RxList<SliderDataModel> sliderList = <SliderDataModel>[].obs;
  RxBool sliderLoad = false.obs;
  getSlider() async {
    sliderLoad.value = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('slider') != null) {
      final data = preferences.getString('slider');
      sliderModel.value = SliderModel.fromJson(jsonDecode(data ?? ""));
      sliderList.value = sliderModel.value.data ?? [];
      if (sliderList.isNotEmpty) {
        sliderLoad.value = false;
      } else {
        sliderLoad.value = false;
      }
    } else {
      try {
        sliderLoad.value = true;
        final resp = await productService.getSlider();
        if (resp != null) {
          sliderModel.value = resp;
          if (sliderModel.value.success ?? false) {
            sliderList.value = sliderModel.value.data ?? [];
            if (sliderList.isNotEmpty) {
              var jsonRes = jsonDecode(jsonEncode(sliderModel));
              await preferences.setString('slider', json.encode(jsonRes));
            }
            sliderLoad.value = false;
          } else {
            Get.snackbar("Error", sliderModel.value.message ?? "",
                messageText: Text(
                  sliderModel.value.message ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.green.shade900,
                  ),
                ),
                backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
                colorText: Colors.green.shade900);
            sliderLoad.value = false;
          }
        } else {
          sliderLoad.value = false;
        }
      } catch (e) {
        sliderLoad.value = false;
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
        if (element.brand?.toLowerCase().contains(search.text.toLowerCase()) ?? false) {
          searchList.add(element);
        } else if (element.company?.toLowerCase().contains(search.text.toLowerCase()) ?? false) {
          searchList.add(element);
        } else if (element.content?.toLowerCase().contains(search.text.toLowerCase()) ?? false) {
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
    if (await isInternet()) {
      if (preferences.getString('history') == null) {
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
      } else {
        isHistoryLoading.value = true;
        final data = preferences.getString('history');
        historyModel.value = HistoryModel.fromJson(jsonDecode(data ?? ""));
        historyList.value = historyModel.value.data ?? [];
        if (historyList.isNotEmpty) {
          isHistoryLoading.value = false;
        }
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
          getCart();
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

  downloadFile(int? id) async {
    await Permission.storage.request();
    try {
      final taskId = await FlutterDownloader.enqueue(
        url: downloadPriceList[id ?? 0].pricepdfUrl ?? "",
        savedDir: "/storage/emulated/0/Download",
        showNotification: true,
        saveInPublicStorage: true,
        openFileFromNotification: true,
      );
      print(taskId);
    } catch (e) {
      print(e);
    }
  }

  RxBool downloadsPriceLoad = false.obs;
  RxBool downloadsProductLoad = false.obs;
  Rx<DownloadModel> downloadModel = DownloadModel().obs;
  RxList<DownloadDataModel> downloadPriceList = <DownloadDataModel>[].obs;
  RxList<DownloadDataModel> downloadProductList = <DownloadDataModel>[].obs;
  getDownloads({bool? pass}) async {
    try {
      downloadsPriceLoad.value = true;
      downloadsProductLoad.value = true;
      final resp = await productService.getDownloads(pass ?? false);
      if (resp != null) {
        downloadModel.value = resp;
        if (downloadModel.value.success ?? false) {
          if (pass ?? false) {
            downloadProductList.value = downloadModel.value.data ?? [];
            downloadsProductLoad.value = false;
          } else {
            downloadPriceList.value = downloadModel.value.data ?? [];
            downloadsPriceLoad.value = false;
          }
        } else {
          Get.snackbar("Error", downloadModel.value.message ?? "",
              messageText: Text(
                downloadModel.value.message ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.green.shade900,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.9),
              colorText: Colors.green.shade900);
          downloadsPriceLoad.value = false;
          downloadsProductLoad.value = false;
        }
      } else {
        downloadsPriceLoad.value = false;
        downloadsProductLoad.value = false;
      }
    } catch (e) {
      downloadsPriceLoad.value = false;
      downloadsProductLoad.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCompany();
    getSlider();
    getCart();
    getProduct();
  }
}
