import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
import 'package:flutter/material.dart';

class ShowProductDetails extends StatelessWidget {
  const ShowProductDetails(
      {Key? key,
      required this.productImage,
      this.title,
      this.subTitle,
      this.trailing,
      this.productPrice,
      this.favouriteIcon,
      this.optionIcon,
      this.isFavourite,
      this.onFavouriteChange,
      this.onOptionIconTap})
      : super(key: key);

  final Widget productImage;
  final String? title;
  final String? subTitle;
  final String? trailing;
  final String? productPrice;
  final bool? favouriteIcon;
  final bool? isFavourite;
  final Function(bool)? onFavouriteChange;
  final IconData? optionIcon;
  final Function()? onOptionIconTap;

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
            AspectRatio(
              aspectRatio: 100 / 50,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: productImage,
                        ),
                      ),
                    ),
                  ),
                  favouriteIcon == true
                      ? Positioned(
                          right: 8,
                          top: 8,
                          child: InkWell(
                            onTap:
                                onFavouriteChange != null && isFavourite != null
                                    ? () => onFavouriteChange!(isFavourite!)
                                    : null,
                            child: Icon(
                              isFavourite == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: getAppColorScheme(context).primary,
                            ),
                          ))
                      : const SizedBox()
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
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        title ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            subTitle ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: getAppTextTheme(context).bodySmall,
                          ),
                        ),
                        trailing != null
                            ? Flexible(
                                child: Text(
                                  trailing ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: getAppTextTheme(context).bodySmall,
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            productPrice ?? "",
                            style: getAppTextTheme(context)
                                .bodyMedium!
                                .copyWith(
                                    color: getAppColorScheme(context).primary,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: InkWell(
                            onTap: onOptionIconTap,
                            child: Icon(
                              optionIcon,
                              size: 20,
                              color: getAppColorScheme(context).primary,
                            ),
                          ),
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
