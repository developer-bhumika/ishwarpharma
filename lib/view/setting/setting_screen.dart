import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ishwarpharma/controller/setting_controller.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';
import 'package:ishwarpharma/view/common_widget/common_tile.dart';

class SettingScreen extends StatelessWidget {
  final settingController = Get.put<SettingController>(SettingController());

  SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: CommonText(
          color: AppColor.textColor,
          fontSize: 18,
          text: "Setting",
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
              text: "General",
              color: AppColor.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            const SizedBox(height: 10),
            CommonTile(
              title: "Display name",
              subTitle: "Test User",
            ),
            const Divider(),
            CommonTile(
              title: "Email",
              subTitle: "test@gmail.com",
            ),
            const Divider(),
            CommonTile(title: "Phone No"),
            const SizedBox(height: 10),
            const CommonText(
              text: "Notification",
              color: AppColor.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTile(
                  title: "New message notification",
                  subTitle: "Display notification",
                ),
                Obx(
                  () => Checkbox(
                    value: settingController.notification.value,
                    fillColor: MaterialStateProperty.all(AppColor.primaryColor),
                    onChanged: (v) {
                      settingController.notification.value = v!;
                    },
                  ),
                )
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
