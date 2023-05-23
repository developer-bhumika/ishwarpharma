import 'package:dio/dio.dart';
import 'package:ishwarpharma/api/dio_client.dart';
import 'package:ishwarpharma/utils/constant.dart';

class ProductApi {
  final DioClient dioClient;

  ProductApi({required this.dioClient});

  Future<Response?> getProduct(FormData body) async {
    try {
      final Response response = await dioClient.post(Endpoints.getProduct, data: body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getCompany() async {
    try {
      final Response? response = await dioClient.get(Endpoints.getCompany);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getDownloadsPrice() async {
    try {
      final Response? response = await dioClient.get(Endpoints.downloadPrice);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getDownloadsProduct() async {
    try {
      final Response? response = await dioClient.get(Endpoints.downloadProduct);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getSlider() async {
    try {
      final Response? response = await dioClient.get(Endpoints.getSlider);
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

  Future<Response?> editCart(FormData body) async {
    try {
      final Response response = await dioClient.post(Endpoints.updateCart, data: body);
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

  Future<Response?> getHistory(FormData data) async {
    try {
      final Response response = await dioClient.post(Endpoints.orderHistory, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> deleteProduct(FormData data) async {
    try {
      final Response response = await dioClient.post(Endpoints.deleteCart, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> addCart(FormData req) async {
    try {
      final Response response = await dioClient.post(Endpoints.cart, data: req);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> orderPlace(FormData req) async {
    try {
      final Response response = await dioClient.post(Endpoints.placeOrder, data: req);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
