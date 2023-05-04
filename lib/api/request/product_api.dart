import 'package:dio/dio.dart';
import 'package:ishwarpharma/api/dio_client.dart';
import 'package:ishwarpharma/utils/constant.dart';

class ProductApi {
  final DioClient dioClient;

  ProductApi({required this.dioClient});

  Future<Response?> getProduct() async {
    try {
      final Response? response = await dioClient.get(Endpoints.getProduct);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> productDetail(int? id) async {
    try {
      final Response? response = await dioClient.get("${Endpoints.productDetail}/$id");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getCart(Map<String, dynamic> params) async {
    try {
      final Response? response = await dioClient.get(Endpoints.cart, queryParameters: params);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
