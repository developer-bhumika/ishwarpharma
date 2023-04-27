import 'package:flutter/material.dart';
import 'package:ishwarpharma/view/common_widget/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: 100,
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) => const ProductCard(),
          ),
        )
      ],
    );
  }
}
