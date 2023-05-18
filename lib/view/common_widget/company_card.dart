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
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primaryColor),
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
      child: Column(
        children: [
          Container(
            height: 85,
            width: 85,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                  imageUrl: imageUrl ?? "",
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Center(child: SizedBox(height: 25, width: 25, child: ProgressView())),
                  errorWidget: (e, es, esq) => const Icon(Icons.error)),
            ),
          ),
          const Spacer(),
          CommonText(text: companyName, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }
}
