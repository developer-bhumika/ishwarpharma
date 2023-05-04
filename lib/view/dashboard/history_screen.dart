import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/cart_card.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: false
          ? const Center(
              child: CommonText(
                fontSize: 20,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
                color: AppColor.primaryColor,
                text: "Your History is Empty",
              ),
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) => CartCard(view: false),
            ),
    );
  }
}
