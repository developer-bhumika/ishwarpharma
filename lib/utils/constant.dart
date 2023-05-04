import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xff009640);
  static const Color secondaryColor = Color(0xffa8c748);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

class AppImage {
  static const String imagePath = "assets/img/";
  static const String logo = "${imagePath}appLogo.png";
}

class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://shop.ishwarpharma.com/api";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;

  static const String getProduct = '/get-products';
  static const String productDetail = '/get-product';
}
