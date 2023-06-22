import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/about_us_screen.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/product_card.dart';
import 'package:ishwarpharma/view/dashboard/contact_us_screen.dart';
import 'package:ishwarpharma/view/dashboard/product_detail_screen.dart';
import 'package:ishwarpharma/view/setting/setting_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final productController = Get.find<ProductController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productController.page.value = 1;
    productController.getProduct(productController.page.value);
  }

  void _onLoading() {
    productController.page.value++;
    productController.getProduct(productController.page.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.black,
            )),
        titleSpacing: 0,
        title: Image.asset(
          AppImage.logo,
          height: 40,
          fit: BoxFit.fill,
        ),
        actions: [
          InkWell(
            onTap: () async {
              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.clear();
              if (await productController.isInternet()) {
                productController.reLoad.value = true;
                await productController.getCompany();
                await productController.getSlider();
                await productController.getProduct(1);
                await productController.getCart();
                await productController.getHistory();
                productController.reLoad.value = false;
                Get.snackbar(
                  "Success",
                  "Data reload successfully",
                  messageText: Text(
                    "Data reload successfully",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: AppColor.primaryColor),
                  ),
                  backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                  colorText: AppColor.primaryColor,
                );
              } else {
                Get.snackbar("Network", "Check your internet connection",
                    messageText: Text(
                      "Check your internet connection",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                    colorText: AppColor.primaryColor);
              }
            },
            child: Obx(
              () => productController.reLoad.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                      child: SizedBox(
                          height: 30, width: 30, child: CircularProgressIndicator(color: AppColor.primaryColor)),
                    )
                  : SvgPicture.asset(AppImage.refresh),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
              onTap: () {
                Get.to(ContactUsScreen());
              },
              child: SvgPicture.asset(AppImage.contactUs)),
          const SizedBox(width: 14),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 14,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextFormField(
              cursorColor: AppColor.primaryColor,
              onChanged: (v) {
                if (v.isEmpty) {
                  productController.searchList.clear();
                  productController.page.value = 1;
                  productController.getProduct(productController.page.value);
                } else {
                  // productController.page.value = 1;
                  productController.getProduct(1, text: v);
                  productController.searchProduct(v);
                }
              },
              controller: productController.search,
              decoration: InputDecoration(
                fillColor: AppColor.white,
                filled: true,
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(7)),
                hintText: "Search Medicine",
                hintStyle: const TextStyle(color: AppColor.greyGreen, fontSize: 14, fontWeight: FontWeight.w400),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(AppImage.search),
                ),
                suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Obx(
                      () => productController.isFilter.value
                          ? InkWell(
                              onTap: () {
                                productController.productList.clear();
                                productController.search.clear();
                                productController.selectedCity = null;
                                productController.isFilter.value = false;
                                productController.page.value = 1;
                                productController.getProduct(productController.page.value);
                              },
                              child: const Icon(Icons.clear, color: AppColor.greyGreen, size: 30),
                            )
                          : InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  ),
                                  backgroundColor: AppColor.white,
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 13),
                                        Row(
                                          children: [
                                            const CommonText(
                                              text: "Filter by",
                                              fontSize: 16,
                                              color: AppColor.textColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            const Spacer(),
                                            InkWell(
                                                onTap: () => Get.back(),
                                                child: const Icon(Icons.close, color: AppColor.greyGreen)),
                                          ],
                                        ),
                                        const SizedBox(height: 30),
                                        const CommonText(
                                          text: "Category",
                                          color: AppColor.dartFontColor,
                                          fontSize: 13,
                                        ),
                                        const SizedBox(height: 20),
                                        StatefulBuilder(
                                          builder: (context, setState) => Container(
                                            height: 48,
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                color: const Color(0xffE3EFE6),
                                                border: Border.all(color: AppColor.borderColor)),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                icon: const Icon(Icons.arrow_drop_down, color: AppColor.primaryColor),
                                                hint: const Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: CommonText(
                                                    text: 'Select Category',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                borderRadius: BorderRadius.circular(6),
                                                value: productController.selectedCity,
                                                isDense: true,
                                                isExpanded: true,
                                                onChanged: (String? newValue) {
                                                  productController.selectedCity = newValue!;
                                                  setState(() {});
                                                },
                                                items: productController.categoryType.map((value) {
                                                  return DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value,
                                                        style: const TextStyle(color: AppColor.black, fontSize: 15)),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 23),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            MaterialButton(
                                                height: 52,
                                                color: AppColor.primaryColor,
                                                onPressed: () async {
                                                  if (productController.selectedCity == null) {
                                                    Get.snackbar("Error", "Please select category",
                                                        backgroundColor: const Color(0xff81B29A).withOpacity(0.3),
                                                        colorText: AppColor.primaryColor);
                                                  } else {
                                                    SharedPreferences preferences =
                                                        await SharedPreferences.getInstance();
                                                    preferences.remove('product');
                                                    productController.search.text = productController.selectedCity!;
                                                    productController.searchProduct(productController.search.text);
                                                    productController.getProduct(1);
                                                    productController.isFilter.value = true;
                                                    Get.back();
                                                  }
                                                },
                                                child: const CommonText(
                                                  text: "Apply",
                                                  color: AppColor.white,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: SvgPicture.asset(AppImage.filter),
                            ),
                    )),
                isDense: true,
              ),
            ),
          ),
          SizedBox(height: 14),
          Obx(() => productController.isLoading.value
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
              : productController.productList.isEmpty
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CommonText(
                            fontSize: 20,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w700,
                            color: AppColor.primaryColor,
                            text: "No Products Available",
                          )
                        ],
                      ),
                    )
                  : Expanded(
                      child: productController.searchList.isNotEmpty
                          ? ListView.separated(
                              itemCount: productController.searchList.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (context, index) => const SizedBox(height: 10),
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  Get.to(ProductDetailScreen(
                                    id: productController.searchList[index].id,
                                    brand_name: productController.searchList[index].brand ?? "",
                                    content: productController.searchList[index].content ?? "",
                                    company: productController.searchList[index].company ?? "",
                                    type: productController.searchList[index].type ?? "",
                                    rate: productController.searchList[index].rate ?? "0",
                                    scheme: productController.searchList[index].free_scheme ?? "0",
                                    caseData: productController.searchList[index].case_value ?? "0",
                                    mrp: productController.searchList[index].mrp.toString(),
                                    pack: productController.searchList[index].pack ?? "0",
                                  ));
                                },
                                child: ProductCard(
                                  title:
                                      "${productController.searchList[index].brand ?? ""} ${productController.searchList[index].pack ?? ""}",
                                  company: productController.searchList[index].company ?? "",
                                  rate: productController.searchList[index].rate ?? "",
                                  mrp: productController.searchList[index].mrp.toString(),
                                  free: productController.productDetailModel.value.data?.free_scheme == ""
                                      ? "0"
                                      : productController.searchList[index].free_scheme ?? "0",
                                  subTitle: productController.searchList[index].content ?? "",
                                  searchTextList: productController.searchTextList,
                                  searchText: productController.search.text,
                                ),
                              ),
                            )
                          : SmartRefresher(
                              controller: productController.refreshController,
                              enablePullUp: productController.pageLoad.value,
                              enablePullDown: false,
                              onLoading: _onLoading,
                              physics: const BouncingScrollPhysics(),
                              child: ListView.separated(
                                itemCount: productController.productList.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                physics: const BouncingScrollPhysics(),
                                separatorBuilder: (context, index) => const SizedBox(height: 10),
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    Get.to(ProductDetailScreen(
                                      id: productController.productList[index].id,
                                      brand_name: productController.productList[index].brand ?? "",
                                      content: productController.productList[index].content ?? "",
                                      type: productController.productList[index].type ?? "",
                                      company: productController.productList[index].company ?? "",
                                      rate: productController.productList[index].rate ?? "0",
                                      scheme: productController.productList[index].free_scheme ?? "0",
                                      caseData: productController.productList[index].case_value ?? "0",
                                      mrp: productController.productList[index].mrp.toString(),
                                      pack: productController.productList[index].pack ?? "0",
                                    ));
                                  },
                                  child: ProductCard(
                                    title:
                                        "${productController.productList[index].brand ?? ""} ${productController.productList[index].pack ?? ""}",
                                    company: productController.productList[index].company ?? "",
                                    rate: productController.productList[index].rate ?? "",
                                    mrp: productController.productList[index].mrp.toString(),
                                    searchText: productController.search.text,
                                    searchTextList: productController.searchTextList,
                                    free: productController.productDetailModel.value.data?.free_scheme == ""
                                        ? "0"
                                        : productController.productList[index].free_scheme ?? "0",
                                    subTitle: productController.productList[index].content ?? "",
                                  ),
                                ),
                              ),
                            ),
                    ))
        ],
      ),
    );
  }
}
