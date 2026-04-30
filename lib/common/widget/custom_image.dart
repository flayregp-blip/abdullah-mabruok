import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CustomImage extends StatelessWidget {
  final Size size;
  final double strokeWidth;
  final String? image;
  final double radius;
  final double? cornerSmoothing;
  final VoidCallback? onTap;
  final bool isShowPlaceHolder;
  final Color? strokeColor;
  final BoxFit? fit;
  final bool isImageLoaderVisible;
  final String? fullName;
  final bool isStokeOutSide;
  final String? placeHolderImage;

  const CustomImage({
    super.key,
    required this.size,
    this.strokeWidth = 0,
    this.image,
    this.radius = 180,
    this.onTap,
    this.cornerSmoothing,
    this.isShowPlaceHolder = false,
    this.strokeColor,
    this.fit,
    this.isImageLoaderVisible = true,
    this.fullName,
    this.isStokeOutSide = true,
    this.placeHolderImage,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl = image ?? '';
    double cornerSmoothing = this.cornerSmoothing ?? 0;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: fit == BoxFit.fitWidth ? null : size.height,
        width: size.width,
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
              cornerRadius: radius, cornerSmoothing: cornerSmoothing),
          child: Stack(
            children: [
              imageUrl.isEmpty
                  ? ImageErrorWidget(
                      size: size,
                      radius: radius,
                      cornerSmoothing: cornerSmoothing,
                      isShowPlaceHolder: isShowPlaceHolder,
                      fullName: fullName,
                      placeHolderImage: placeHolderImage,
                    )
                  : Container(
                      height: fit == BoxFit.fitWidth ? null : size.height,
                      width: size.width,
                      margin: EdgeInsets.all(!isStokeOutSide ? 0 : strokeWidth),
                      constraints: BoxConstraints(maxHeight: size.height),
                      child: ClipSmoothRect(
                        radius: SmoothBorderRadius(
                            cornerRadius: radius,
                            cornerSmoothing: cornerSmoothing),
                        child: CachedNetworkImage(
                          fit: fit ?? BoxFit.cover,
                          imageUrl: imageUrl,
                          cacheKey: imageUrl,
                          placeholder: (context, url) {
                            return isImageLoaderVisible
                                ? Shimmer.fromColors(
                                    baseColor: bgGrey(context),
                                    highlightColor: bgMediumGrey(context),
                                    child: Container(
                                      height: size.height,
                                      width: size.width,
                                      decoration: BoxDecoration(
                                          color: bgGrey(context),
                                          borderRadius:
                                              BorderRadius.circular(radius)),
                                    ))
                                : const SizedBox();
                          },
                          errorWidget: (context, error, stackTrace) {
                            return ImageErrorWidget(
                                size: size,
                                radius: radius,
                                cornerSmoothing: cornerSmoothing,
                                isShowPlaceHolder: isShowPlaceHolder,
                                fullName: fullName,
                                placeHolderImage: placeHolderImage);
                          },
                        ),
                      ),
                    ),
              if (strokeWidth > 0)
                Container(
                  height: size.height,
                  width: size.width,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(cornerRadius: radius),
                      side: BorderSide(
                          color: strokeColor ??
                              whitePure(context).withValues(alpha: .3),
                          width: strokeWidth),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageErrorWidget extends StatelessWidget {
  final double radius;
  final double cornerSmoothing;
  final bool isShowPlaceHolder;
  final Size size;
  final String? fullName;
  final double? placeHolderColorOpacity;
  final String? placeHolderImage;

  const ImageErrorWidget(
      {super.key,
      required this.radius,
      required this.cornerSmoothing,
      this.isShowPlaceHolder = false,
      required this.size,
      this.fullName,
      this.placeHolderColorOpacity,
      this.placeHolderImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
                cornerRadius: radius, cornerSmoothing: cornerSmoothing)),
        gradient: isShowPlaceHolder
            ? StyleRes.disabledGreyGradient(
                opacity: placeHolderColorOpacity ?? 1)
            : StyleRes.themeGradient,
      ),
      alignment: Alignment.center,
      child: isShowPlaceHolder
          ? LayoutBuilder(builder: (context, constraints) {
              return Image.asset(placeHolderImage ?? AssetRes.icNoImage,
                  height: constraints.maxHeight / 2,
                  width: constraints.maxWidth / 2,
                  color: textDarkGrey(context));
            })
          : Text(
              (fullName?[0] ?? AppRes.appName[0]).toUpperCase(),
              style: TextStyleCustom.unboundedMedium500(
                  fontSize:
                      size.height / 2, // Fallback to 50 if size is not finite
                  color: whitePure(context),
                  opacity: 0.4),
            ),
    );
  }
}
