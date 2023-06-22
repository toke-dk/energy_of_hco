import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
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
                        favouriteIcon: true,
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

class ShowProductDetails extends StatelessWidget {
  const ShowProductDetails(
      {Key? key,
      required this.productImage,
      this.title,
      this.subTitle,
      this.trailing,
      this.productPrice,
      required this.favouriteIcon,
      this.optionIcon})
      : super(key: key);

  final Widget productImage;
  final String? title;
  final String? subTitle;
  final String? trailing;
  final String? productPrice;
  final bool favouriteIcon;
  final IconData? optionIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 184,
        minHeight: 184,
        maxWidth: 184,
        maxHeight: 184,
      ),
      child: MyPaper(
        hasShadow: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 90,
              child: Stack(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      child: productImage),
                  Positioned(
                      right: 0,
                      child: IconButton(
                          onPressed: () {},
                          icon: favouriteIcon
                              ? Icon(
                                  Icons.favorite_border,
                                  color: getAppColorScheme(context).primary,
                                )
                              : const SizedBox()))
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 13, right: 13, bottom: 11),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        title ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            subTitle ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: getAppTextTheme(context).subtitle1,
                          ),
                        ),
                        trailing != null ? Flexible(
                          child: Text(
                            trailing ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: getAppTextTheme(context).subtitle1,
                          ),
                        ) : SizedBox()
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          productPrice ?? "",
                          style: TextStyle(
                              color: getAppColorScheme(context).primary,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          child: Icon(
                            optionIcon,
                            size: 20,
                            color: getAppColorScheme(context).primary,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}