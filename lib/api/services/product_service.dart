import 'package:dio/dio.dart';
import 'package:ishwarpharma/api/dio_exceptions.dart';
import 'package:ishwarpharma/api/request/product_api.dart';
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
}
