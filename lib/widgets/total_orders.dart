import 'package:energy_of_hco/models/order.dart';
import 'package:energy_of_hco/widgets/days_scroll.dart';
import 'package:energy_of_hco/widgets/show_product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalOrders extends StatelessWidget {
  const TotalOrders({Key? key,}) : super(key: key);

  List<Order> getOrdersForDay(context) {
    return Provider.of<OrdersProvider>(context).getOrdersForDay;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            Order currentIndexOrder = getOrdersForDay(context)[index];
            int amountOfProducts = currentIndexOrder.cart.allProducts;
            return Center(
              child: Column(
                children: [
                  Container(
                    height: 180,
                      width: 180,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      child: ShowProductDetails(
                          title: currentIndexOrder.user.firstName,
                          subTitle: amountOfProducts.toString() + " product${amountOfProducts!=1 ? 's' : ''}",
                          productPrice: currentIndexOrder.totalPrice.toString(),
                          optionIcon: Icons.edit,
                          productImage: currentIndexOrder
                              .cart.cartItems.first.product.image)),
                ],
              ),
            );
          },
          itemCount: getOrdersForDay(context).length),
    );
  }
}
