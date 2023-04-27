import 'package:flutter/material.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class ProductCardColumn extends StatelessWidget {
  String? title;
  String? subTitle;
  ProductCardColumn({Key? key, this.title, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(text: title ?? "", fontWeight: FontWeight.w500),
          const SizedBox(height: 5),
          CommonText(text: subTitle ?? ""),
        ],
      ),
    );
  }
}
