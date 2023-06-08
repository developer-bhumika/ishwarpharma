import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/view/common_widget/product_card_column.dart';

class ProductCard extends StatelessWidget {
  String? title;
  String? company;
  String? rate;
  String? mrp;
  String? free;
  String? subTitle;
  RxList<String>? searchTextList;
  String? searchText;
  ProductCard(
      {Key? key,
      this.title,
      this.company,
      this.rate,
      this.mrp,
      this.free,
      this.subTitle,
      this.searchTextList,
      this.searchText})
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
    String brandName = title?.replaceAll(exp, '') ?? "";
    String content = subTitle?.replaceAll(exp, '') ?? "";
    return Container(
      decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColor.borderColor)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: highlightOccurrences(brandName, searchText ?? ' '),
                style: const TextStyle(
                    color: AppColor.primaryColor, fontWeight: FontWeight.w500),
              ),
            ),
            const Divider(
              color: AppColor.borderColor,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductCardColumn(
                    title: "Company",
                    subTitle: company ?? "",
                    searchText: searchText ?? "",
                    flex: 2),
                ProductCardColumn(
                  title: "Rate",
                  subTitle: rate ?? "",
                  searchText: "",
                ),
                ProductCardColumn(
                    title: "MRP", subTitle: mrp ?? "", searchText: ""),
                ProductCardColumn(
                  title: "Free",
                  subTitle: free ?? "",
                  searchText: "",
                ),
              ],
            ),
            const Divider(
              color: AppColor.borderColor,
              thickness: 1,
            ),
            Text.rich(
              TextSpan(
                children: highlightOccurrences(content, searchText ?? ''),
                style: const TextStyle(
                    color: AppColor.dartFontColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
