import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class CartCard extends StatelessWidget {
  bool? view;
  CartCard({Key? key, this.view}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primaryColor),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CommonText(
                  text: "DOBLUTECH 250",
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 5),
                CommonText(text: "BLUTECH 250", fontSize: 12),
              ],
            ),
          ),
          Column(
            children: [
              view ?? true ? const Icon(Icons.delete, color: AppColor.primaryColor) : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}
