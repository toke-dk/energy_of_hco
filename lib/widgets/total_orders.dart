import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
import 'package:energy_of_hco/widgets/show_product_detail.dart';
import 'package:flutter/material.dart';

class TotalOrders extends StatelessWidget {
  const TotalOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Center(
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      child: ShowProductDetails(
                        title: "John D.",
                        subTitle: "3 items (2 x monster, 1x red bull)",
                        productPrice: "50,32 kr.",
                        optionIcon: Icons.edit,
                        productImage: Image.network(
                            'https://cdn.bevco.dk/cdn-cgi/image/format%3Dauto/https%3A//cdn.bevco.dk/thumbnail/d3/15/55/1644401459/monster-energy-24x50-cl-daase-449cc_644x644.png'),
                      )),
                ],
              ),
            );
          },
          separatorBuilder: (context, idex) => const SizedBox(
                width: 19,
              ),
          itemCount: 10),
    );
  }
}