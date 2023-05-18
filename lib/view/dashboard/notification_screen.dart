import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/product_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) => Container(
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
                        children: [
                          const CommonText(
                            text: "Notification title",
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          const SizedBox(height: 5),
                          const CommonText(
                            text: "Description",
                          ),
                          const SizedBox(height: 5),
                          CommonText(
                            text: DateTime.now().toString(),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColor.primaryColor,
                      child: Icon(Icons.notifications, color: AppColor.white),
                    ),
                  ],
                ),
              )),
    );
  }
}
