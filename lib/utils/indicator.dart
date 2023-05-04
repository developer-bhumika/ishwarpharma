import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';

class ProgressView extends StatelessWidget {
  Color? color;
  ProgressView({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppColor.primaryColor,
      ),
    );
  }
}
