import 'package:dio/dio.dart';
import 'package:ishwarpharma/api/dio_exceptions.dart';
import 'package:ishwarpharma/api/request/product_api.dart';
import 'package:ishwarpharma/model/cart_model.dart';
import 'package:ishwarpharma/model/product_detail_model.dart';
import 'package:ishwarpharma/model/product_model.dart';
import 'package:ishwarpharma/view/dashboard/product_detail_screen.dart';

class ProductService {
  final ProductApi productApi;

  ProductService(this.productApi);

  Future<ProductModel?> getProduct() async {
    try {
      final response = await productApi.getProduct();
      if (response != null) {
        return ProductModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<ProductDetailModel?> productDetail(int? id) async {
    try {
      final response = await productApi.productDetail(id);
      if (response != null) {
        return ProductDetailModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<CartModel?> getCart(Map<String, dynamic> params) async {
    try {
      final response = await productApi.getCart(params);
      if (response != null) {
        return CartModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<CartModel?> addCart({
    String? deviceId,
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
      final formData = FormData.fromMap({
        "device_id": deviceId,
        "product_id": product_id,
        "brand_name": brand_name,
        "company": company,
        "pack": pack,
        "content": content,
        "rate": rate,
        "scheme": scheme,
        "mrp": mrp,
        "qty": qty,
        "remark": remark,
        "case": caseData
      });
      final response = await productApi.addCart(formData);
      if (response != null) {
        return CartModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }
}
