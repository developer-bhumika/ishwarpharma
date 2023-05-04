import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class CommonButton extends StatelessWidget {
  final void Function()? onTap;
  final String? btnText;
  final Color? color;
  final double? fontSize;
  final bool? load;

  CommonButton({
    this.onTap,
    this.btnText,
    this.color,
    this.fontSize,
    this.load,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      height: 60,
      minWidth: MediaQuery.of(context).size.width,
      elevation: 0,
      color: color ?? AppColor.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: load ?? false
          ? ProgressView(
              color: AppColor.white,
            )
          : CommonText(
              text: btnText ?? '',
              color: AppColor.white,
              fontSize: fontSize ?? 18,
              fontWeight: FontWeight.w500,
            ),
    );
  }
}
