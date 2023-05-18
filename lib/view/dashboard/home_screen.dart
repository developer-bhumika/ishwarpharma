import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/company_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Obx(
            () => productController.companyLoad.value
                ? SizedBox(height: 200, width: Get.width, child: ProgressView())
                : CarouselSlider(
                    options: CarouselOptions(height: 200.0, autoPlay: true, viewportFraction: 1),
                    items: productController.sliderList.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: i.sliderUrl ?? "",
                                fit: BoxFit.fill,
                                placeholder: (context, url) => SizedBox(height: 25, width: 25, child: ProgressView()),
                                errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 15),
          const CommonText(
              text: "Shop by Company", fontSize: 18, color: AppColor.primaryColor, fontWeight: FontWeight.w600),
          const SizedBox(height: 15),
          Obx(
            () => productController.companyLoad.value
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Center(child: CircularProgressIndicator(color: AppColor.primaryColor)),
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
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: productController.companyList.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              productController.search.text = productController.companyList[index].name!;

                              productController.searchProduct(productController.search.text);
                            },
                            child: CompanyCard(
                              imageUrl: productController.companyList[index].logoUrl ?? "",
                              companyName: productController.companyList[index].name ?? "",
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
