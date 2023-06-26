import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/models/order.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
import 'package:energy_of_hco/widgets/show_product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalOrders extends StatelessWidget {
  const TotalOrders({Key? key}) : super(key: key);

  List<Order> getOrders(context) {
    return Provider.of<OrderProvider>(context).getOrders;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            Order currentIndexOrder = getOrders(context)[index];
            return Center(
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      child: ShowProductDetails(
                        title: currentIndexOrder.user.firstName,
                        subTitle: currentIndexOrder.cart.cartItems.length.toString(),
                        productPrice: currentIndexOrder.totalPrice.toString(),
                        optionIcon: Icons.edit,
                        productImage: currentIndexOrder.cart.cartItems.first.product.image
                      )),
                ],
              ),
            );
          },
          separatorBuilder: (context, idex) => const SizedBox(
                width: 19,
              ),
          itemCount: getOrders(context).length),
    );
  }
}