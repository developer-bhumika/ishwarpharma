import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class AboutUsScreen extends StatelessWidget {
  AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const CommonText(
          text: "About Us",
          color: AppColor.white,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text:
                  "Ishwar Pharma is a leading distributor of quality generic medicines in Maharashtra currently associated with Abbott, Wockhardt, Emcure, Sandoz, Troikaa, Indian Immunoglobins, Tripada, Jackson and many other companies.",
            ),
            SizedBox(height: 15),
            CommonText(
              text:
                  "Disclaimer: This application does not support online billing, payment or pharmacy. it is not for end retailers and only meant for authorized Ishwar Pharma stockiest to communicate orders.",
            ),
            SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: const [
                    CommonText(
                      text: "Contact Us:",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CommonText(text: ""),
                    SizedBox(height: 5),
                    CommonText(text: "Website: www.ishwarpharma.com"),
                    SizedBox(height: 2),
                    CommonText(text: "Email: ishwarpharma@gmail.com"),
                    SizedBox(height: 2),
                    CommonText(text: "(0): 022-66155679 / 66155680"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
