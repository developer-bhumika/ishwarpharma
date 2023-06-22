import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';

class CommonText extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? fontSize;
  final double? textHeight;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  const CommonText({
    super.key,
    this.text,
    this.color,
    this.fontSize,
    this.textHeight,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      maxLines: 1,
      style: TextStyle(
          color: color ?? AppColor.dartFontColor,
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w400,
          height: textHeight,
          fontFamily: "Poppins"),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}
