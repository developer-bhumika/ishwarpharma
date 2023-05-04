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
        style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.primaryColor, backgroundColor: Colors.yellow),
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
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.secondaryColor.withOpacity(0.2),
              AppColor.primaryColor.withOpacity(0.2),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*   searchText?.contains(" ") ?? false
                  ? Text.rich(
                      TextSpan(
                        children: [
                          for (int i = 0; i < num.parse(searchTextList?.length.toString() ?? "0"); i++)
                            // highlightOccurrences(title ?? '', searchTextList?[i] ?? '')
                        ],
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  :*/
              Text.rich(
                TextSpan(
                  children: highlightOccurrences(title ?? '', searchText ?? ''),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              // CommonText(
              //   text: title ?? "",
              //   fontWeight: FontWeight.w600,
              //   color: /* isCheck ?? false ? AppColor.primaryColor : */ Colors.black,
              // ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductCardColumn(title: "Company", subTitle: company ?? "", searchText: searchText),
                  ProductCardColumn(title: "Rate", subTitle: rate ?? ""),
                  ProductCardColumn(title: "MRP", subTitle: mrp ?? ""),
                  ProductCardColumn(title: "Free", subTitle: free ?? ""),
                ],
              ),
              const Divider(),
              Text.rich(
                TextSpan(
                  children: highlightOccurrences(subTitle ?? '', searchText ?? ''),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
