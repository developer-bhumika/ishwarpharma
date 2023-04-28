import 'package:flutter/material.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class CommonTile extends StatelessWidget {
  String? title;
  String? subTitle;
  CommonTile({Key? key, this.title, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(text: title ?? ""),
        const SizedBox(height: 3),
        CommonText(
          text: subTitle ?? "",
          fontSize: 12,
          color: Colors.grey,
        ),
      ],
    );
  }
}
