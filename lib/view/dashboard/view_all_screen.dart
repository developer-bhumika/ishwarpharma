import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/main.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/company_card.dart';
import 'package:ishwarpharma/view/dashboard/products_screen.dart';

class ViewAllScreen extends StatelessWidget {
  ViewAllScreen({Key? key}) : super(key: key);

  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.black,
          ),
        ),
        centerTitle: true,
        title: CommonText(
          color: AppColor.textColor,
          fontSize: 18,
          text: "Companies",
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
      ),
      body: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: MediaQuery.of(context).size.aspectRatio / 0.5,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: productController.companyList.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            productController.search.text = productController.companyList[index].name!;
            productController.searchProduct(productController.search.text);
            // BottomNavigationBar navigationBar = bottomWidgetKey.currentWidget as BottomNavigationBar;
            // navigationBar.onTap!(1);
            Get.to(ProductsScreen());
          },
          child: CompanyCard(
            imageUrl: productController.companyList[index].logoUrl ?? "",
            companyName: productController.companyList[index].name ?? "",
          ),
        ),
      ),
    );
  }
}
