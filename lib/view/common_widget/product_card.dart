import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/product_card_column.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        // border: Border(
        //   left: BorderSide(color: AppColor.primaryColor),
        //   top: BorderSide(color: AppColor.primaryColor),
        //   bottom: BorderSide(color: AppColor.secondaryColor),
        //   right: BorderSide(color: AppColor.secondaryColor),
        // ),
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
            const CommonText(text: "Perasitamol", fontWeight: FontWeight.w600),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductCardColumn(title: "Company", subTitle: "Protech"),
                ProductCardColumn(title: "Rate", subTitle: "Rs. 162.00"),
                ProductCardColumn(title: "MRP", subTitle: "Rs. 339.00"),
                ProductCardColumn(title: "Free", subTitle: "Scheme 5..%"),
              ],
            ),
            const Divider(),
            const CommonText(text: "Haperine 25000iu/5ml", fontWeight: FontWeight.w500),
          ],
        ),
      ),
    );
  }
}
