import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/company_card.dart';

class HomeScreen extends StatelessWidget {
  TabController? tabController;
  HomeScreen({Key? key, this.tabController}) : super(key: key);

  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: "Shop by Company",
            fontSize: 18,
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 15),
          Obx(
            () => productController.companyLoad.value
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Center(
                          child: CircularProgressIndicator(color: AppColor.primaryColor),
                        ),
                      ],
                    ),
                  )
                : productController.companyList.isEmpty
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Center(
                              child: CommonText(
                                fontSize: 20,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w700,
                                color: AppColor.primaryColor,
                                text: "No Company Available",
                              ),
                            )
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: productController.companyList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              productController.search.text = productController.companyList[index].company!;

                              productController.searchProduct(productController.search.text);

                              tabController?.animateTo(1, curve: const ElasticInCurve());
                            },
                            child: CompanyCard(
                              companyName: productController.companyList[index].company ?? "",
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
