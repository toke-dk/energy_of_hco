import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShowProductDetails extends StatelessWidget {
  const ShowProductDetails({
    Key? key,
    required this.productImage,
    this.title,
    this.subTitle,
    this.trailing,
    this.productPrice,
    this.favouriteIcon,
    this.optionChild,
    this.isFavourite,
    this.onFavouriteChange,
  }) : super(key: key);

  final Widget productImage;
  final String? title;
  final String? subTitle;
  final String? trailing;
  final String? productPrice;
  final bool? favouriteIcon;
  final bool? isFavourite;
  final Function(bool)? onFavouriteChange;
  final Widget? optionChild;

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
                              onTap: onFavouriteChange != null &&
                                      isFavourite != null
                                  ? () => onFavouriteChange!(isFavourite!)
                                  : null,
                              child: Animate(
                                  target: isFavourite == true ? 1 : 0,
                                  effects: isFavourite == true
                                      ? [
                                          ScaleEffect(
                                              duration: 100.milliseconds,
                                              end: const Offset(1.2, 1.2)),
                                          ThenEffect(delay: 120.milliseconds),
                                          ScaleEffect(
                                              duration: 100.milliseconds,
                                              end: const Offset(
                                                  1 / 1.2, 1 / 1.2))
                                        ]
                                      : [
                                          ShakeEffect(
                                              hz: 5,
                                              duration: 600.milliseconds,
                                              curve: Curves.easeInOut)
                                        ],
                                  child: Icon(
                                    isFavourite == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: getAppColorScheme(context).primary,
                                  ))))
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
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: optionChild)),
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
