import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class AboutUsScreen extends StatelessWidget {
  AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const CommonText(
          color: AppColor.textColor,
          fontSize: 18,
          text: "About Us",
          fontWeight: FontWeight.w500,
        ),
        shadowColor: AppColor.borderColor2,
        centerTitle: true,
        elevation: 0.75,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText(
              text:
                  "Ishwar Pharma is a leading distributor of quality generic medicines in Maharashtra currently associated with Abbott, Wockhardt, Emcure, Sandoz, Troikaa, Indian Immunoglobins, Tripada, Jackson and many other companies.",
            ),
            const SizedBox(height: 15),
            const CommonText(
              text:
                  "Disclaimer: This application does not support online billing, payment or pharmacy. it is not for end retailers and only meant for authorized Ishwar Pharma stockiest to communicate orders.",
            ),
            const SizedBox(height: 15),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CommonText(text: ""),
                      const SizedBox(height: 5),
                      RichText(
                          text: const TextSpan(
                              text: "Website: ",
                              style: TextStyle(fontFamily: "Poppins", color: AppColor.dartFontColor),
                              children: [
                            TextSpan(
                                text: "www.ishwarpharma.com",
                                style: TextStyle(
                                    color: AppColor.primaryColor, fontWeight: FontWeight.w500, fontFamily: "Poppins"))
                          ])),
                      const SizedBox(height: 2),
                      RichText(
                          text: const TextSpan(
                              text: "Email: ",
                              style: TextStyle(fontFamily: "Poppins", color: AppColor.dartFontColor),
                              children: [
                            TextSpan(
                                text: "ishwarpharma@gmail.com",
                                style: TextStyle(
                                    color: AppColor.primaryColor, fontWeight: FontWeight.w500, fontFamily: "Poppins"))
                          ])),
                      const SizedBox(height: 2),
                      RichText(
                          text: const TextSpan(
                              text: "(0): ",
                              style: TextStyle(fontFamily: "Poppins", color: AppColor.dartFontColor),
                              children: [
                            TextSpan(
                                text: "022-66155679 / 66155680",
                                style: TextStyle(
                                    color: AppColor.primaryColor, fontWeight: FontWeight.w500, fontFamily: "Poppins"))
                          ])),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
