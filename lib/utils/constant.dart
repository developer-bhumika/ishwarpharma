import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xff1EB28F);
  static const Color secondaryColor = Color(0xff96BF24);
  static const Color borderColor = Color(0xffEBF5ED);
  static const Color dartFontColor = Color(0xff2D4D3C);
  static const Color greyGreen = Color(0xff889990);
  static const Color teal = Color(0xffDBFFED);
  static const Color borderColorProduct = Color(0xffE3EFE6);
  static const Color textColor = Color(0xff21262D);
  static const Color lightGreen = Color(0xffF2FBF4);
  static const Color scaffoldBgColor = Color(0xffEFF9FF);
  static const Color borderColor2 = Color(0xffEDF3FC);
  static const Color blue = Color(0xff179DFF);
  static const Color grey = Color(0xff7C8899);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

class AppImage {
  static const String imagePath = "assets/img/";
  static const String logo = "${imagePath}logo.png";
  static const String more = "${imagePath}more.svg";
  static const String refresh = "${imagePath}refresh.svg";
  static const String contactUs = "${imagePath}contactUs.svg";
  static const String searchColor = "${imagePath}searchColor.svg";
  static const String cartColor = "${imagePath}cartColor.svg";
  static const String notificationColor = "${imagePath}notificationColor.svg";
  static const String downloadColor = "${imagePath}downloadColor.svg";
  static const String historyColor = "${imagePath}historyColor.svg";
  static const String homeColor = "${imagePath}homeColor.svg";
  static const String emptyCart = "${imagePath}cart.png";
  static const String searchText = "${imagePath}searchText.svg";
  static const String filter = "${imagePath}filter.svg";
  static const String cart = "${imagePath}cart.svg";
  static const String download = "${imagePath}download.svg";
  static const String history = "${imagePath}history.svg";
  static const String home = "${imagePath}home.svg";
  static const String notification = "${imagePath}notification.svg";
  static const String search = "${imagePath}search.svg";
  static const String profile = "${imagePath}profile.svg";
  static const String profileColor = "${imagePath}profileColor.svg";
  static const String catalogue = "${imagePath}catalogue.svg";
  static const String priceList = "${imagePath}priceList.svg";
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
  static const String getCompany = '/recommended-company';
  static const String getCategory = '/get-category';
  static const String getSlider = '/slider';
  static const String productDetail = '/get-product';
  static const String updateCart = '/update-cart';
  static const String cart = '/cart';
  static const String deleteCart = '/delete-cart';
  static const String orderHistory = '/order-history';
  static const String placeOrder = '/place-order';
  static const String downloadPrice = '/download-price';
  static const String downloadProduct = '/download-product';
}
