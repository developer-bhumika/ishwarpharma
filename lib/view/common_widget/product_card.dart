import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/product_card_column.dart';

class ProductCard extends StatelessWidget {
  String? title;
  String? company;
  String? rate;
  String? mrp;
  String? free;
  String? subTitle;
  ProductCard({
    Key? key,
    this.title,
    this.company,
    this.rate,
    this.mrp,
    this.free,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.secondaryColor.withOpacity(0.2),
              AppColor.primaryColor.withOpacity(0.2),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(text: title ?? "", fontWeight: FontWeight.w600),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductCardColumn(title: "Company", subTitle: company ?? ""),
                  ProductCardColumn(title: "Rate", subTitle: rate ?? ""),
                  ProductCardColumn(title: "MRP", subTitle: mrp ?? ""),
                  ProductCardColumn(title: "Free", subTitle: free ?? ""),
                ],
              ),
              const Divider(),
              CommonText(text: subTitle ?? "", fontWeight: FontWeight.w500),
            ],
          ),
        ),
      ),
    );
  }
}
