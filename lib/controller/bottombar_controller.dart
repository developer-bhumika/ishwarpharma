import 'package:get/get.dart';
import 'package:ishwarpharma/view/dashboard/cart_screen.dart';
import 'package:ishwarpharma/view/dashboard/download.dart';
import 'package:ishwarpharma/view/dashboard/history_screen.dart';
import 'package:ishwarpharma/view/dashboard/home_screen.dart';
import 'package:ishwarpharma/view/dashboard/notification_screen.dart';
import 'package:ishwarpharma/view/dashboard/products_screen.dart';

class BottomBarController extends GetxController {
  RxBool notification = false.obs;
  RxInt selectedIndex = 0.obs;
  RxList pageList = [
    HomeScreen(),
    ProductsScreen(),
    CartScreen(),
    HistoryScreen(),
    NotificationScreen(),
    DownloadScreen(),
  ].obs;
}
