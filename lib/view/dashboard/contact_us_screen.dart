import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColor.primaryColor, AppColor.secondaryColor],
            ),
          ),
        ),
        centerTitle: true,
        title: const CommonText(
          text: "Contact Us",
          color: AppColor.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CommonText(
                text: "ISHWAR PHARMA",
                fontSize: 18,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor.borderColorProduct),
                  borderRadius: BorderRadius.circular(6),
                  color: AppColor.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CommonText(
                          text: "Address : ",
                          fontSize: 14,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: InkWell(
                          onTap: () async {
                            List<Location> coordinates = await locationFromAddress(
                                "7 DEVKARAN MANSION, 24 VITHALDAS ROAD, DAWA BAZAR, MUMBAI 400002");
                            // final uri = Uri.parse(
                            //     'https://www.google.com/maps/search/?api=1&query=${coordinates[0].latitude},${coordinates[0].longitude}');
                            // if (await canLaunchUrl(uri)) {
                            //   await launchUrl(uri);
                            // } else {
                            //   throw 'Could not launch $uri';
                            // }

                            String appleUrl =
                                'https://maps.apple.com/?saddr=&daddr=${coordinates[0].latitude},${coordinates[0].longitude}&directionsmode=driving';
                            String googleUrl =
                                'https://www.google.com/maps/search/${Uri.encodeFull("7 DEVKARAN MANSION, 24 VITHALDAS ROAD, DAWA BAZAR, MUMBAI 400002")}';

                            if (Platform.isIOS) {
                              if (await canLaunchUrl(Uri.parse(appleUrl))) {
                                await launchUrl(Uri.parse(appleUrl));
                              } else {
                                if (await canLaunchUrl(Uri.parse(googleUrl))) {
                                  await launchUrl(Uri.parse(googleUrl));
                                } else {
                                  throw 'Could not open the map.';
                                }
                              }
                            } else {
                              if (await canLaunchUrl(Uri.parse(googleUrl))) {
                                await launchUrl(Uri.parse(googleUrl));
                              } else {
                                throw 'Could not open the map.';
                              }
                            }
                          },
                          child: CommonText(
                            text: "7 DEVKARAN MANSION, 24 VITHALDAS ROAD, DAWA BAZAR, MUMBAI 400002",
                            fontSize: 14,
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: CommonText(
                          text: "Email : ",
                          fontSize: 14,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: InkWell(
                          onTap: () {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'ishwarpharma@gmail.com',
                            );

                            launchUrl(emailLaunchUri);
                          },
                          child: const CommonText(
                            text: "ishwarpharma@gmail.com",
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: CommonText(
                          text: "Contact : ",
                          fontSize: 14,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Brijesh Shah ",
                                  children: [
                                    TextSpan(
                                      text: "9820061593",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          final Uri launchUri = Uri(
                                            scheme: 'tel',
                                            path: "9820061593",
                                          );
                                          await launchUrl(launchUri);
                                        },
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                  style:
                                      const TextStyle(fontSize: 14, fontFamily: "Poppins", color: AppColor.textColor),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "Apurva Shah ",
                                  children: [
                                    TextSpan(
                                      text: "9833064770",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          final Uri launchUri = Uri(
                                            scheme: 'tel',
                                            path: "9833064770",
                                          );
                                          await launchUrl(launchUri);
                                        },
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                  style:
                                      const TextStyle(fontSize: 14, fontFamily: "Poppins", color: AppColor.textColor),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: CommonText(
                          text: "Hours : ",
                          fontSize: 14,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            CommonText(
                              text: "Monday - Friday: 9am - 5pm",
                              fontSize: 14,
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w400,
                            ),
                            CommonText(
                              text: "Saturday - Sunday: Closed",
                              fontSize: 14,
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
