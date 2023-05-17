import 'package:flutter/material.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CommonText(text: "Downloads"),
      ),
    );
  }
}
