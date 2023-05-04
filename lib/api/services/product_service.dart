import 'package:dio/dio.dart';
import 'package:ishwarpharma/api/dio_exceptions.dart';
import 'package:ishwarpharma/api/request/product_api.dart';
import 'package:ishwarpharma/model/cart_model.dart';
import 'package:ishwarpharma/model/product_model.dart';

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
}
