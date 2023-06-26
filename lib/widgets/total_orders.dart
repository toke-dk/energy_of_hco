import 'package:energy_of_hco/models/order.dart';
import 'package:energy_of_hco/widgets/days_scroll.dart';
import 'package:energy_of_hco/widgets/show_product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalOrders extends StatelessWidget {
  const TotalOrders({Key? key, required this.date}) : super(key: key);
  final DateTime date;

  List<Order> getOrders(context) {
    return Provider.of<OrderProvider>(context).getOrders;
  }

  List<Order> ordersForDay(context) {
    return getOrders(context)
        .where((Order order) => order.date.isSameDate(date))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            Order currentIndexOrder = ordersForDay(context)[index];
            return Center(
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      child: ShowProductDetails(
                          title: currentIndexOrder.user.firstName,
                          subTitle: currentIndexOrder.cart.cartItems.length
                              .toString(),
                          productPrice: currentIndexOrder.totalPrice.toString(),
                          optionIcon: Icons.edit,
                          productImage: currentIndexOrder
                              .cart.cartItems.first.product.image)),
                ],
              ),
            );
          },
          separatorBuilder: (context, idex) => const SizedBox(
                width: 19,
              ),
          itemCount: ordersForDay(context).length),
    );
  }
}
