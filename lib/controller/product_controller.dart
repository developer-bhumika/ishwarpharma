import 'package:get/get.dart';
import 'package:ishwarpharma/api/service_locator.dart';
import 'package:ishwarpharma/api/services/product_service.dart';
import 'package:ishwarpharma/model/product_model.dart';

class ProductController extends GetxController {
  final productService = getIt.get<ProductService>();
  RxBool isLoading = true.obs;
  RxList<ProductDataModel> productList = <ProductDataModel>[].obs;
  Rx<ProductModel> productModel = ProductModel().obs;

  getProduct() async {
    try {
      isLoading.value = true;
      final resp = await productService.getProduct();
      if (resp != null) {
        productModel.value = resp;
        if (productModel.value.success ?? false) {
          productList.value = productModel.value.data ?? [];
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

  @override
  void onInit() {
    super.onInit();
    getProduct();
  }
}
