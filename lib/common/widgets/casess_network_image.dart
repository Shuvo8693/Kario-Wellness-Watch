import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final BoxFit? boxFit;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    required this.imageUrl,
    this.backgroundColor,
    this.height,
    this.width,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: boxFit ?? BoxFit.cover,
      imageBuilder:
          (context, imageProvider) => Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              border: border,
              borderRadius: borderRadius,
              shape: boxShape,
              color: backgroundColor,
              image:
                  imageUrl.isEmpty
                      ? DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fitHeight,
                        colorFilter: colorFilter,
                      )
                      : DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: colorFilter,
                      ),
            ),
            child: child,
          ),
      placeholder:
          (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.6),
            highlightColor: Colors.grey.withOpacity(0.3),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                border: border,
                color: Colors.grey.withOpacity(0.6),
                borderRadius: borderRadius,
                shape: boxShape,
              ),
            ),
          ),
      errorWidget:
          (context, url, error) => Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              border: border,
              color: Colors.grey.withOpacity(0.6),
              borderRadius: borderRadius,
              shape: boxShape,
            ),
            // child: const Icon(Icons.error),
          ),
    );
  }
}
