import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ishwarpharma/api/service_locator.dart';
import 'package:ishwarpharma/api/services/product_service.dart';
import 'package:ishwarpharma/model/cart_model.dart';
import 'package:ishwarpharma/model/category_model.dart';
import 'package:ishwarpharma/model/company_model.dart';
import 'package:ishwarpharma/model/download_model.dart';
import 'package:ishwarpharma/model/download_product_model.dart';
import 'package:ishwarpharma/model/focus_product_model.dart';
import 'package:ishwarpharma/model/history_model.dart';
import 'package:ishwarpharma/model/new_arrival_model.dart';
import 'package:ishwarpharma/model/product_detail_model.dart';
import 'package:ishwarpharma/model/product_model.dart';
import 'package:ishwarpharma/model/slider_model.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  final productService = getIt.get<ProductService>();
  RxBool isLoading = false.obs;
  RxList<ProductDataModel> productList = <ProductDataModel>[].obs;
  RxList<ProductDataModel> searchList = <ProductDataModel>[].obs;
  Rx<ProductModel> productModel = ProductModel().obs;
  RxList<ProductDataModel> productIndList = <ProductDataModel>[].obs;
  TextEditingController firm = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController moNo = TextEditingController();
  RxList<dynamic> notificationList = <dynamic>[].obs;

  RxBool reLoad = false.obs;
  String? selectedCity;
  RxBool isFilter = false.obs;
  RxList<String> cityList = ["Surat", "Vapi", "Ahmedabad", "Vadodara"].obs;

  RxBool notification = false.obs;

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
              backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
              colorText: AppColor.primaryColor);
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

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxBool pageLoad = true.obs;

  getProduct(int page, {String? text}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if ((!await isInternet()) && preferences.getString('product') != null) {
      isLoading.value = true;
      final data = preferences.getString('product');
      productModel.value = ProductModel.fromJson(jsonDecode(data ?? ""));
      productList.addAll(productModel.value.data ?? []);
      if (productList.isNotEmpty) {
        productList.sort((a, b) => a.brand!.compareTo(b.brand ?? ""));
        isLoading.value = false;
      }
    } else {
      try {
        if (page == 1) {
          isLoading.value = true;
          productList.clear();
          searchList.clear();
        }
        final resp = await productService.getProduct(text ?? search.text, page);
        if (resp != null) {
          productModel.value = resp;
          if (productModel.value.success ?? false) {
            productList.addAll(productModel.value.data ?? []);
            refreshController.loadComplete();
            if (productList.isNotEmpty) {
              productList.sort((a, b) => a.brand!.compareTo(b.brand ?? ""));
              var jsonRes = jsonDecode(jsonEncode(productModel));
              await preferences.setString('product', json.encode(jsonRes));
            }
            if (productModel.value.data?.isEmpty ?? true) {
              pageLoad.value = false;
            } else {
              pageLoad.value = true;
            }
            isLoading.value = false;
          } else {
            Get.snackbar("Error", productModel.value.message ?? "",
                messageText: Text(
                  productModel.value.message ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColor.primaryColor,
                  ),
                ),
                backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                colorText: AppColor.primaryColor);
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
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColor.primaryColor,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
              colorText: AppColor.primaryColor);
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColor.primaryColor,
                  ),
                ),
                backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                colorText: AppColor.primaryColor);
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

  Rx<CategoryModel> categoryModel = CategoryModel().obs;
  RxList<CategoryData> categoryList = <CategoryData>[].obs;
  RxList<String> categoryType = <String>[].obs;
  RxBool categoryLoad = false.obs;
  getCategory() async {
    try {
      categoryLoad.value = true;
      final resp = await productService.getCategory();
      if (resp != null) {
        categoryModel.value = resp;
        if (categoryModel.value.success ?? false) {
          categoryList.value = categoryModel.value.data ?? [];
          for (var element in categoryList) {
            if (element.type == "0" || element.type == "") {
              categoryType.remove(element.type);
            } else {
              categoryType.add(element.type?.replaceAll("\n", " ") ?? "");
            }
          }

          categoryLoad.value = false;
        } else {
          Get.snackbar("Error", categoryModel.value.message ?? "",
              messageText: Text(
                categoryModel.value.message ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColor.primaryColor,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
              colorText: AppColor.primaryColor);
          categoryLoad.value = false;
        }
      } else {
        categoryLoad.value = false;
      }
    } catch (e) {
      categoryLoad.value = false;
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColor.primaryColor,
                  ),
                ),
                backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                colorText: AppColor.primaryColor);
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

  Rx<NewArrivalModel> newArrivalModel = NewArrivalModel().obs;
  RxList<NewArrivalData> newArrivalList = <NewArrivalData>[].obs;
  RxBool newArrivalLoad = false.obs;
  newArrival() async {
    newArrivalLoad.value = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('newArrival') != null) {
      final data = preferences.getString('newArrival');
      newArrivalModel.value = NewArrivalModel.fromJson(jsonDecode(data ?? ""));
      newArrivalList.value = newArrivalModel.value.data ?? [];
      if (newArrivalList.isNotEmpty) {
        newArrivalLoad.value = false;
      } else {
        newArrivalLoad.value = false;
      }
    } else {
      try {
        newArrivalLoad.value = true;
        final resp = await productService.newArrival();
        if (resp != null) {
          newArrivalModel.value = resp;
          if (newArrivalModel.value.success ?? false) {
            newArrivalList.value = newArrivalModel.value.data ?? [];
            if (newArrivalList.isNotEmpty) {
              var jsonRes = jsonDecode(jsonEncode(newArrivalModel));
              await preferences.setString('newArrival', json.encode(jsonRes));
            }
            newArrivalLoad.value = false;
          } else {
            Get.snackbar("Error", newArrivalModel.value.message ?? "",
                messageText: Text(
                  newArrivalModel.value.message ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColor.primaryColor,
                  ),
                ),
                backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                colorText: AppColor.primaryColor);
            newArrivalLoad.value = false;
          }
        } else {
          newArrivalLoad.value = false;
        }
      } catch (e) {
        newArrivalLoad.value = false;
      }
    }
  }

  Rx<FocusProductModel> focusProductModel = FocusProductModel().obs;
  RxList<FocusData> focusDataList = <FocusData>[].obs;
  RxBool focusLoad = false.obs;
  focusProduct() async {
    focusLoad.value = true;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('focusProduct') != null) {
      final data = preferences.getString('focusProduct');
      focusProductModel.value =
          FocusProductModel.fromJson(jsonDecode(data ?? ""));
      focusDataList.value = focusProductModel.value.data ?? [];
      if (focusDataList.isNotEmpty) {
        focusLoad.value = false;
      } else {
        focusLoad.value = false;
      }
    } else {
      try {
        focusLoad.value = true;
        final resp = await productService.focusProduct();
        if (resp != null) {
          focusProductModel.value = resp;
          if (focusProductModel.value.success ?? false) {
            focusDataList.value = focusProductModel.value.data ?? [];
            if (focusDataList.isNotEmpty) {
              var jsonRes = jsonDecode(jsonEncode(focusProductModel));
              await preferences.setString('focusProduct', json.encode(jsonRes));
            }
            focusLoad.value = false;
          } else {
            Get.snackbar("Error", focusProductModel.value.message ?? "",
                messageText: Text(
                  focusProductModel.value.message ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColor.primaryColor,
                  ),
                ),
                backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                colorText: AppColor.primaryColor);
            focusLoad.value = false;
          }
        } else {
          focusLoad.value = false;
        }
      } catch (e) {
        focusLoad.value = false;
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
          } else if (element.company?.toLowerCase().contains(e.toLowerCase()) ??
              false) {
            searchList.add(element);
          } else if (element.content?.toLowerCase().contains(e.toLowerCase()) ??
              false) {
            searchList.add(element);
          }
        }
      }
    } else {
      for (var element in productList) {
        RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
        String brandName = element.content?.replaceAll(exp, '') ?? "";
        if (element.brand?.toLowerCase().contains(search.text.toLowerCase()) ??
            false) {
          searchList.add(element);
        } else if (element.company
                ?.toLowerCase()
                .contains(search.text.toLowerCase()) ??
            false) {
          searchList.add(element);
        } else if (brandName
            .toLowerCase()
            .contains(search.text.toLowerCase())) {
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
      String? deviceId;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
      Map<String, dynamic> params = {"device_id": deviceId};
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
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColor.primaryColor),
            ),
            backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
            colorText: AppColor.primaryColor,
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

      final resp =
          await productService.deleteProduct(androidInfo.id, id.toString());
      if (resp != null) {
        if (resp['success'] ?? false) {
          cartList.removeAt(index ?? 0);
          return deleteProductLoading.value = false;
        } else {
          Get.snackbar("Error", cartModel.value.message ?? "",
              messageText: Text(
                cartModel.value.message ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColor.primaryColor,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
              colorText: AppColor.primaryColor);
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
      String? deviceId;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }

      final resp = await productService.orderPlace(
        deviceId: deviceId,
        email: email.text,
        mobileNo: moNo.text,
        firmName: firm.text,
        place: place.text,
      );
      if (resp != null) {
        if (resp['success'] ?? false) {
          Get.back();
          SharedPreferences preferences = await SharedPreferences.getInstance();

          preferences.remove('history');
          await getHistory();
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
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColor.primaryColor,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
              colorText: AppColor.primaryColor);
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

    if (preferences.getString('history') == null) {
      try {
        isHistoryLoading.value = true;
        String? deviceId;
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceId = androidInfo.id;
        } else {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceId = iosInfo.identifierForVendor;
        }
        final resp = await productService.getHistory(deviceId ?? "");
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColor.primaryColor,
                  ),
                ),
                backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                colorText: AppColor.primaryColor);
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
      String? deviceId;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }

      final resp = await productService.addCart(
        brand_name: brand_name,
        caseData: caseData,
        company: company,
        content: content,
        deviceId: deviceId,
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
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColor.primaryColor,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
              colorText: AppColor.primaryColor);
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

  RxDouble progressDownload = 0.0.obs;
  // downloadFile(
  //   String? url,
  //   index,
  // ) async {
  //   try {
  //     //You can download a single file
  //     FileDownloader.downloadFile(
  //         url: url ?? "",
  //         name: 'ishwarpharma',
  //         onProgress: (String? fileName, double? progress) {
  //           progressDownload.value = (progress! / 100);
  //         },
  //         onDownloadCompleted: (String path) async {
  //           downloadPriceList[index].load.value = false;
  //           downloadProductList[index].load.value = false;
  //           OpenFilex.open(path);
  //           Get.snackbar("Success", "File downloaded successfully",
  //               messageText: const Text(
  //                 "File downloaded successfully",
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.w500,
  //                   fontSize: 13,
  //                   color: AppColor.primaryColor,
  //                 ),
  //               ),
  //               backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
  //               colorText: AppColor.primaryColor);
  //         },
  //         onDownloadError: (String error) {
  //           downloadPriceList[index].load.value = false;
  //           downloadProductList[index].load.value = false;
  //         });
  //   } catch (e) {
  //     downloadPriceList[index].load.value = false;
  //     downloadProductList[index].load.value = false;
  //   }
  // }

  void downloadFile(String? url, int index) async {
    final Dio dio = Dio();

    try {
      String savePath = Platform.isAndroid
          ? "/storage/emulated/0/Download/ishwarpharma${DateTime.now().toString().replaceAll("-", "").replaceAll(" ", "").replaceAll(":", "")}.pdf"
          : '${Directory.systemTemp.path}/ishwarpharma${DateTime.now()}.pdf';
      await dio.download(url ?? "", savePath,
          onReceiveProgress: (receivedBytes, totalBytes) {
        if (totalBytes != -1) {
          // Calculate download progress percentage
          progressDownload.value = (receivedBytes / totalBytes);
          print('Download progress: ${progressDownload.value}%');

          if (progressDownload.value == 1.0) {
            OpenFilex.open(savePath);
            downloadPriceList[index].load.value = false;
            downloadProductList[index].load.value = false;
          }
        } else {
          progressDownload.value = 0.0;
        }
      });

      print('File downloaded successfully');
    } catch (e) {
      print('Download error: $e');
      downloadPriceList[index].load.value = false;
      downloadProductList[index].load.value = false;
    }
  }

  RxBool downloadsPriceLoad = false.obs;
  RxBool downloadsProductLoad = false.obs;
  Rx<DownloadModel> downloadModel = DownloadModel().obs;
  Rx<DownLoadProductModel> downloadProductModel = DownLoadProductModel().obs;
  RxList<DownloadDataModel> downloadPriceList = <DownloadDataModel>[].obs;
  RxList<DownloadProductDataModel> downloadProductList =
      <DownloadProductDataModel>[].obs;
  getDownloads() async {
    try {
      downloadsPriceLoad.value = true;

      final resp = await productService.getDownloadPrice();
      if (resp != null) {
        downloadModel.value = resp;
        if (downloadModel.value.success ?? false) {
          downloadPriceList.value = downloadModel.value.data ?? [];
          downloadsPriceLoad.value = false;
        } else {
          Get.snackbar("Error", downloadModel.value.message ?? "",
              messageText: Text(
                downloadModel.value.message ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColor.primaryColor,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
              colorText: AppColor.primaryColor);
          downloadsPriceLoad.value = false;
        }
      } else {
        downloadsPriceLoad.value = false;
      }
    } catch (e) {
      downloadsPriceLoad.value = false;
    }
  }

  getDownLoadProduct() async {
    try {
      downloadsProductLoad.value = true;
      final resp = await productService.getDownloadProduct();
      if (resp != null) {
        downloadProductModel.value = resp;
        if (downloadProductModel.value.success ?? false) {
          downloadProductList.value = downloadProductModel.value.data ?? [];
          downloadsProductLoad.value = false;
        } else {
          Get.snackbar("Error", downloadProductModel.value.message ?? "",
              messageText: Text(
                downloadProductModel.value.message ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColor.primaryColor,
                ),
              ),
              backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
              colorText: AppColor.primaryColor);
          downloadsProductLoad.value = false;
        }
      } else {
        downloadsProductLoad.value = false;
      }
    } catch (e) {
      downloadsProductLoad.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCompany();
    getSlider();
    getCart();
    getCategory();
    newArrival();
    focusProduct();
    // getProduct();
  }
}
