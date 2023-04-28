import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ishwarpharma/api/dio_client.dart';
import 'package:ishwarpharma/api/request/product_api.dart';
import 'package:ishwarpharma/api/services/product_service.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton(Dio());
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerSingleton(ProductApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(ProductService(getIt.get<ProductApi>()));
}
