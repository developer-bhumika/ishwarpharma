import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ishwarpharma/utils/constant.dart';
import 'package:ishwarpharma/utils/indicator.dart';
import 'package:ishwarpharma/view/common_widget/common_text.dart';

class CompanyCard extends StatelessWidget {
  String? companyName;
  String? imageUrl;
  CompanyCard({Key? key, this.companyName, this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: const Color(0xffC9DECE).withOpacity(0.24), blurRadius: 17),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 90,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child: CachedNetworkImage(
                  imageUrl: imageUrl ?? "",
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Center(child: SizedBox(height: 25, width: 25, child: ProgressView())),
                  errorWidget: (e, es, esq) => const Icon(Icons.error)),
            ),
          ),
          Expanded(
            child: CommonText(text: companyName ?? "", fontWeight: FontWeight.w500, color: AppColor.textColor),
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
