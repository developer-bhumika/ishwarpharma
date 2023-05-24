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
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: AppColor.primaryColor, backgroundColor: Colors.yellow),
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
                children: highlightOccurrences(title ?? '', searchText ?? ''),
                style: const TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.w500),
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
                ProductCardColumn(title: "Company", subTitle: company ?? "", searchText: searchText, flex: 2),
                ProductCardColumn(title: "Rate", subTitle: rate ?? ""),
                ProductCardColumn(title: "MRP", subTitle: mrp ?? ""),
                ProductCardColumn(title: "Free", subTitle: free ?? ""),
              ],
            ),
            const Divider(
              color: AppColor.borderColor,
              thickness: 1,
            ),
            Text.rich(
              TextSpan(
                children: highlightOccurrences(subTitle ?? '', searchText ?? ''),
                style: const TextStyle(color: AppColor.dartFontColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
