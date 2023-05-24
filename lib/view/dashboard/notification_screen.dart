import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final productController = Get.find<ProductController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
        title: CommonText(
          text: "Notification",
          color: AppColor.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: productController.notificationList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.borderColorProduct),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: productController.notificationList[index]['title'],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppColor.primaryColor,
                            ),
                            const SizedBox(height: 5),
                            CommonText(
                              text: productController.notificationList[index]['body'],
                            ),
                            const SizedBox(height: 5),
                            CommonText(
                              text: DateFormat("yyyy-MM-dd")
                                  .add_jm()
                                  .format(DateTime.parse(productController.notificationList[index]["time"])),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.notifications, color: AppColor.primaryColor),
                    ],
                  ),
                )),
      ),
    );
  }
}
