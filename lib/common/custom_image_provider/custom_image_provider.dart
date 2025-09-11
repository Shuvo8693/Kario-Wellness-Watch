import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:kario_wellness_watch/common/app_icons/app_icons.dart';

enum ImageType { asset, network, file, svg }

/// A comprehensive image asset management class with modern package integration
class ImageAsset {
  final String path;
  final String? package;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;
  final Color? color;
  final BlendMode? colorBlendMode;
  final String? semanticLabel;
  final ImageType imageType;

  const ImageAsset(
      this.path, {
        this.package,
        this.width,
        this.height,
        this.fit,
        this.alignment,
        this.color,
        this.colorBlendMode,
        this.semanticLabel,
        this.imageType = ImageType.asset,
      });

  /// Factory constructors for different image types
  factory ImageAsset.network(
      String url, {
        double? width,
        double? height,
        BoxFit? fit,
        AlignmentGeometry? alignment,
        Color? color,
        BlendMode? colorBlendMode,
        String? semanticLabel,
      }) {
    return ImageAsset(
      url,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      imageType: ImageType.network,
    );
  }

  factory ImageAsset.file(
      String filePath, {
        double? width,
        double? height,
        BoxFit? fit,
        AlignmentGeometry? alignment,
        Color? color,
        BlendMode? colorBlendMode,
        String? semanticLabel,
      }) {
    return ImageAsset(
      filePath,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      imageType: ImageType.file,
    );
  }

  factory ImageAsset.svg(
      String path, {
        String? package,
        double? width,
        double? height,
        BoxFit? fit,
        AlignmentGeometry? alignment,
        Color? color,
        BlendMode? colorBlendMode,
        String? semanticLabel,
      }) {
    return ImageAsset(
      path,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      imageType: ImageType.svg,
    );
  }

  /// Create from XFile (image_picker result)
  factory ImageAsset.fromXFile(
      XFile xFile, {
        double? width,
        double? height,
        BoxFit? fit,
        AlignmentGeometry? alignment,
      }) {
    return ImageAsset(
      xFile.path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      imageType: ImageType.file,
    );
  }

  /// Get responsive width using ScreenUtil
  double? get responsiveWidth => width?.w;

  /// Get responsive height using ScreenUtil
  double? get responsiveHeight => height?.h;

  /// Check if the image is SVG
  bool get isSvg => imageType == ImageType.svg || path.toLowerCase().endsWith('.svg');

  /// Check if the image is network image
  bool get isNetwork => imageType == ImageType.network || path.startsWith('http');

  /// Check if the image is file
  bool get isFile => imageType == ImageType.file;

  /// Create appropriate widget based on image type
  Widget toImage({
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Color? color,
    BlendMode? colorBlendMode,
    String? semanticLabel,
    FilterQuality filterQuality = FilterQuality.low,
    bool excludeFromSemantics = false,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    bool useResponsiveSize = false,
  }) {
    final finalWidth = useResponsiveSize
        ? (width?.w ?? responsiveWidth)
        : (width ?? this.width);
    final finalHeight = useResponsiveSize
        ? (height?.h ?? responsiveHeight)
        : (height ?? this.height);

    if (isSvg) {
      return _buildSvgPicture(
        width: finalWidth,
        height: finalHeight,
        fit: fit ?? this.fit ?? BoxFit.contain,
        alignment: alignment ?? this.alignment ?? Alignment.center,
        color: color ?? this.color,
        semanticsLabel: semanticLabel ?? this.semanticLabel,
      );
    }

    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: path,
        width: finalWidth,
        height: finalHeight,
        fit: fit ?? this.fit,
        alignment: (alignment ?? this.alignment ?? Alignment.center) as Alignment,
        color: color ?? this.color,
        colorBlendMode: colorBlendMode ?? this.colorBlendMode,
        placeholder: (context, url) => loadingBuilder?.call(context, Container(), null) ??
            Container(
              width: finalWidth,
              height: finalHeight,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
        errorWidget: (context, url, error) => errorBuilder?.call(context, error, null) ??
            Container(
              width: finalWidth,
              height: finalHeight,
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            ),
      );
    }

    if (isFile) {
      return Image.file(
        File(path),
        width: finalWidth,
        height: finalHeight,
        fit: fit ?? this.fit,
        alignment: alignment ?? this.alignment ?? Alignment.center,
        color: color ?? this.color,
        colorBlendMode: colorBlendMode ?? this.colorBlendMode,
        semanticLabel: semanticLabel ?? this.semanticLabel,
        filterQuality: filterQuality,
        excludeFromSemantics: excludeFromSemantics,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
      );
    }

    // Default asset image
    return Image.asset(
      path,
      package: package,
      width: finalWidth,
      height: finalHeight,
      fit: fit ?? this.fit,
      alignment: alignment ?? this.alignment ?? Alignment.center,
      color: color ?? this.color,
      colorBlendMode: colorBlendMode ?? this.colorBlendMode,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      filterQuality: filterQuality,
      excludeFromSemantics: excludeFromSemantics,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
    );
  }

  /// Build SVG Picture widget
  Widget _buildSvgPicture({
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Color? color,
    String? semanticsLabel,
  }) {
    if (isNetwork) {
      return SvgPicture.network(
        path,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        alignment: alignment ?? Alignment.center,
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        semanticsLabel: semanticsLabel,
        placeholderBuilder: (context) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (isFile) {
      return SvgPicture.file(
        File(path),
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        alignment: alignment ?? Alignment.center,
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        semanticsLabel: semanticsLabel,
      );
    }

    // Asset SVG
    return SvgPicture.asset(
      path,
      package: package,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      alignment: alignment ?? Alignment.center,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      semanticsLabel: semanticsLabel,
    );
  }

  /// Create a circular avatar from this asset
  Widget toCircularAvatar({
    double? radius,
    Color? backgroundColor,
    Color? foregroundColor,
    ImageErrorWidgetBuilder? onBackgroundImageError,
    bool useResponsiveSize = false,
  }) {
    final finalRadius = useResponsiveSize ? radius?.r : radius;

    if (isSvg) {
      return CircleAvatar(
        radius: finalRadius,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        child: ClipOval(
          child: _buildSvgPicture(
            width: finalRadius != null ? finalRadius * 2 : null,
            height: finalRadius != null ? finalRadius * 2 : null,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (isNetwork) {
      return CircleAvatar(
        radius: finalRadius,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        backgroundImage: CachedNetworkImageProvider(path),
       // onBackgroundImageError: onBackgroundImageError,
      );
    }

    if (isFile) {
      return CircleAvatar(
        radius: finalRadius,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        backgroundImage: FileImage(File(path)),
       // onBackgroundImageError: onBackgroundImageError,
      );
    }

    return CircleAvatar(
      radius: finalRadius,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      backgroundImage: AssetImage(path, package: package),
     // onBackgroundImageError: onBackgroundImageError,
    );
  }

  /// Create a container with this image as background
  Widget toBackgroundContainer({
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Decoration? foregroundDecoration,
    BoxConstraints? constraints,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    bool useResponsiveSize = false,
  }) {
    final finalWidth = useResponsiveSize
        ? (width?.w ?? responsiveWidth)
        : (width ?? this.width);
    final finalHeight = useResponsiveSize
        ? (height?.h ?? responsiveHeight)
        : (height ?? this.height);

    if (isSvg) {
      return Container(
        width: finalWidth,
        height: finalHeight,
        padding: padding,
        margin: margin,
        constraints: constraints,
        transform: transform,
        transformAlignment: transformAlignment,
        foregroundDecoration: foregroundDecoration,
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildSvgPicture(
                fit: fit ?? this.fit ?? BoxFit.cover,
                alignment: alignment ?? this.alignment ?? Alignment.center,
                color: color,
              ),
            ),
            if (child != null) child,
          ],
        ),
      );
    }

    DecorationImage? decorationImage;

    if (isNetwork) {
      decorationImage = DecorationImage(
        image: CachedNetworkImageProvider(path),
        fit: fit ?? this.fit ?? BoxFit.cover,
        alignment: alignment ?? this.alignment ?? Alignment.center,
        colorFilter: color != null
            ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn)
            : null,
      );
    } else if (isFile) {
      decorationImage = DecorationImage(
        image: FileImage(File(path)),
        fit: fit ?? this.fit ?? BoxFit.cover,
        alignment: alignment ?? this.alignment ?? Alignment.center,
        colorFilter: color != null
            ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn)
            : null,
      );
    } else {
      decorationImage = DecorationImage(
        image: AssetImage(path, package: package),
        fit: fit ?? this.fit ?? BoxFit.cover,
        alignment: alignment ?? this.alignment ?? Alignment.center,
        colorFilter: color != null
            ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn)
            : null,
      );
    }

    return Container(
      width: finalWidth,
      height: finalHeight,
      padding: padding,
      margin: margin,
      constraints: constraints,
      transform: transform,
      transformAlignment: transformAlignment,
      foregroundDecoration: foregroundDecoration,
      decoration: BoxDecoration(image: decorationImage),
      child: child,
    );
  }

  /// Create an ImageProvider from this asset
  ImageProvider toImageProvider() {
    if (isNetwork) {
      return CachedNetworkImageProvider(path);
    }
    if (isFile) {
      return FileImage(File(path));
    }
    return AssetImage(path, package: package);
  }

  /// Create a hero widget with this image
  // Widget toHero({
  //   required String tag,
  //   double? width,
  //   double? height,
  //   BoxFit? fit,
  //   CreateRectTween? createRectTween,
  //   Widget Function(BuildContext, Widget)? placeholderBuilder,
  //   Widget Function(BuildContext, Size, Widget)? flightShuttleBuilder,
  //   HeroFlightDirection? flightDirection,
  //   bool transitionOnUserGestures = false,
  //   bool useResponsiveSize = false,
  // }) {
  //   return Hero(
  //     tag: tag,
  //     createRectTween: createRectTween,
  //     placeholderBuilder: placeholderBuilder,
  //     flightShuttleBuilder: flightShuttleBuilder,
  //     flightDirection: flightDirection,
  //     transitionOnUserGestures: transitionOnUserGestures,
  //     child: toImage(
  //       width: width,
  //       height: height,
  //       fit: fit,
  //       useResponsiveSize: useResponsiveSize,
  //     ),
  //   );
  // }

  /// Save network image to device storage
  Future<String?> saveToDevice({String? fileName}) async {
    if (!isNetwork) return null;

    try {
      final response = await http.get(Uri.parse(path));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final name = fileName ?? 'image_${DateTime.now().millisecondsSinceEpoch}';
        final file = File('${directory.path}/$name');
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
    }
    return null;
  }

  /// Copy this ImageAsset with new parameters
  ImageAsset copyWith({
    String? path,
    String? package,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Color? color,
    BlendMode? colorBlendMode,
    String? semanticLabel,
    ImageType? imageType,
  }) {
    return ImageAsset(
      path ?? this.path,
      package: package ?? this.package,
      width: width ?? this.width,
      height: height ?? this.height,
      fit: fit ?? this.fit,
      alignment: alignment ?? this.alignment,
      color: color ?? this.color,
      colorBlendMode: colorBlendMode ?? this.colorBlendMode,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      imageType: imageType ?? this.imageType,
    );
  }

  @override
  String toString() {
    return 'ImageAsset(path: $path, type: $imageType, package: $package, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageAsset &&
        other.path == path &&
        other.package == package &&
        other.width == width &&
        other.height == height &&
        other.fit == fit &&
        other.alignment == alignment &&
        other.color == color &&
        other.colorBlendMode == colorBlendMode &&
        other.semanticLabel == semanticLabel &&
        other.imageType == imageType;
  }

  @override
  int get hashCode {
    return Object.hash(
      path,
      package,
      width,
      height,
      fit,
      alignment,
      color,
      colorBlendMode,
      semanticLabel,
      imageType,
    );
  }
}

/// ========== Extension to make it easier to create ImageAsset from strings ===================
extension StringToImageAsset on String {
  ImageAsset toImageAsset({
    String? package,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Color? color,
    BlendMode? colorBlendMode,
    String? semanticLabel,
    ImageType? imageType,
  }) {
    return ImageAsset(
      this,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      imageType: imageType ?? _detectImageType(this),
    );
  }

  ImageType _detectImageType(String path) {
    if (path.startsWith('http')) return ImageType.network;
    if (path.toLowerCase().endsWith('.svg')) return ImageType.svg;
    if (path.startsWith('/')) return ImageType.file;
    return ImageType.asset;
  }
}

///================= A collection class to manage multiple image assets ==================
class ImageAssets {
  static const String _baseImagePath = 'assets/image/';
  static const String _baseIconPath = 'assets/icons/';
 // static const String _svgPath = 'assets/svg/';

  // Example static image assets
  static final ImageAsset logo = ImageAsset(
    '${_baseIconPath}logo.png',
    width: 100,
    height: 100,
    fit: BoxFit.contain,
  );

  static final ImageAsset logoSvg = ImageAsset.svg(
    '$_baseIconPath${AppIcons.appIcons}',
    width: 100,
    height: 100,
    color: Colors.blue,
  );

  static final ImageAsset backgroundImage = ImageAsset(
    '${_baseImagePath}background.jpg',
    fit: BoxFit.cover,
  );

  static final ImageAsset profilePlaceholder = ImageAsset(
    '${_baseImagePath}profile_placeholder.png',
    width: 50,
    height: 50,
    fit: BoxFit.cover,
  );

  // SVG icons
  static final ImageAsset homeIcon = ImageAsset.svg('${_baseIconPath}home.svg');
  static final ImageAsset profileIcon = ImageAsset.svg('${_baseIconPath}profile.svg');
  static final ImageAsset settingsIcon = ImageAsset.svg('${_baseIconPath}settings.svg');

  // Network images
  static ImageAsset networkImage(String url, {double? width, double? height}) {
    return ImageAsset.network(url, width: width, height: height);
  }

  // Get image by name
  static ImageAsset getImage(String name, {
    double? width,
    double? height,
    BoxFit? fit,
    bool isSvg = false,
  }) {
    final path = isSvg ? '$_baseIconPath$name' : '$_baseIconPath$name';
    return ImageAsset(
      path,
      width: width,
      height: height,
      fit: fit,
      imageType: isSvg ? ImageType.svg : ImageType.asset,
    );
  }

  // Get SVG icon with color
  static ImageAsset getSvgIcon(String name, {
    double? size,
    Color? color,
  }) {
    return ImageAsset.svg(
      '$_baseIconPath$name.svg',
      width: size,
      height: size,
      color: color,
    );
  }
}

// ================================ Example usage class ==================================
class ImageAssetExample extends StatelessWidget {
  const ImageAssetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ImageAsset Example')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Regular image
            ImageAssets.logo.toImage(useResponsiveSize: true),

            SizedBox(height: 20.h),

            // SVG image with color
            ImageAssets.logoSvg.toImage(
              color: Colors.red,
              useResponsiveSize: true,
            ),

            SizedBox(height: 20.h),

            // Network image with caching
            ImageAsset.network(
              'https://via.placeholder.com/200x200',
              width: 200,
              height: 200,
            ).toImage(useResponsiveSize: true),

            SizedBox(height: 20.h),

            // SVG from network
            ImageAsset.svg(
              'https://www.svgrepo.com/show/13654/avatar.svg',
            ).toImage(
              width: 100.w,
              height: 100.h,
              color: Colors.purple,
            ),

            SizedBox(height: 20.h),

            // Circular avatar with SVG
            Center(
              child: ImageAssets.homeIcon.toCircularAvatar(
                radius: 30.r,
                backgroundColor: Colors.blue[100],
              ),
            ),

            SizedBox(height: 20.h),

            // Background container with SVG
            Container(
              height: 200.h,
              child: ImageAssets.profileIcon.toBackgroundContainer(
                useResponsiveSize: true,
                child: Center(
                  child: Text(
                    'SVG Background',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Using string extension
            'assets/svg/icon.svg'.toImageAsset(
              width: 50,
              height: 50,
              color: Colors.green,
            ).toImage(useResponsiveSize: true),
          ],
        ),
      ),
    );
  }
}