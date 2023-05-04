import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class ProductCardColumn extends StatelessWidget {
  String? title;
  String? subTitle;
  String? searchText;
  ProductCardColumn({Key? key, this.title, this.subTitle, this.searchText}) : super(key: key);

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.primaryColor),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(text: title ?? "", fontWeight: FontWeight.w500),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: highlightOccurrences(subTitle ?? '', searchText ?? ''),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
