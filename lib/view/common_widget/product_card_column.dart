import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class ProductCardColumn extends StatelessWidget {
  String? title;
  String? subTitle;
  String? searchText;
  CrossAxisAlignment? alignment;
  int? flex;
  ProductCardColumn(
      {Key? key,
      this.title,
      this.subTitle,
      this.searchText,
      this.alignment,
      this.flex})
      : super(key: key);
  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: source)];
    }

    var matches = <Match>[];
    for (final token in query.trim().toLowerCase().split(' ')) {
      matches.addAll(token.allMatches(source.toLowerCase()));
    }

    if (matches.isEmpty) {
      return [TextSpan(text: source)];
    }
    matches.sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    final List<TextSpan> children = [];
    for (final match in matches) {
      if (match.end <= lastMatchEnd) {
        // already matched -> ignore
      } else if (match.start <= lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.end),
          style: const TextStyle(
              fontWeight: FontWeight.bold, backgroundColor: Colors.yellow),
        ));
      } else if (match.start > lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));

        children.add(TextSpan(
          text: source.substring(match.start, match.end),
          style: const TextStyle(
              fontWeight: FontWeight.bold, backgroundColor: Colors.yellow),
        ));
      }

      if (lastMatchEnd < match.end) {
        lastMatchEnd = match.end;
      }
    }

    if (lastMatchEnd < source.length) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, source.length),
      ));
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String companyName = subTitle?.replaceAll(exp, '') ?? "";
    return Expanded(
      flex: flex ?? 1,
      child: Column(
        crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
        children: [
          CommonText(
              text: title ?? "",
              fontWeight: FontWeight.w400,
              color: AppColor.greyGreen,
              fontSize: 12),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: highlightOccurrences(companyName, searchText ?? ''),
              style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
