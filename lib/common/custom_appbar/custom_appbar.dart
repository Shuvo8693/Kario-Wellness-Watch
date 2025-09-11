import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kario_wellness_watch/common/app_color/app_colors.dart';
import 'package:kario_wellness_watch/common/app_icons/app_icons.dart';
import 'package:kario_wellness_watch/common/svg_base64/ExtractionBase64Image.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final VoidCallback? onBackPressed;
  final bool automaticallyImplyLeading;
  final double? titleSpacing;
  final double? leadingWidth;
  final TextStyle? titleTextStyle;
  final bool showLogo;
  final double toolbarHeight;
  final ShapeBorder? shape;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool transparent; // New parameter for transparency

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.onBackPressed,
    this.automaticallyImplyLeading = true,
    this.titleSpacing,
    this.leadingWidth,
    this.titleTextStyle,
    this.showLogo = false,
    this.toolbarHeight = kToolbarHeight,
    this.shape,
    this.shadowColor,
    this.surfaceTintColor,
    this.systemOverlayStyle,
    this.transparent = false, // Default to false for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildTitle(),
      actions: actions,
      leading: _buildLeading(context),
      backgroundColor: transparent
          ? Colors.transparent
          : (backgroundColor ?? AppColors.primaryColor),
      foregroundColor: foregroundColor,
      elevation: transparent ? 0 : elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleSpacing: titleSpacing,
      leadingWidth: leadingWidth,
      titleTextStyle: titleTextStyle,
      toolbarHeight: toolbarHeight,
      shape: shape,
      shadowColor: transparent ? Colors.transparent : shadowColor,
      surfaceTintColor: transparent ? Colors.transparent : surfaceTintColor,
      systemOverlayStyle: transparent
          ? SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            )
          : systemOverlayStyle,
      // Add these properties for true transparency
      flexibleSpace: transparent
          ? Container(
              decoration: const BoxDecoration(color: Colors.transparent),
            )
          : null,
      // Force the AppBar to be truly transparent
      scrolledUnderElevation: transparent ? 0 : null,
    );
  }

  Widget? _buildTitle() {
    if (showLogo) {
      return ExtractBase64ImageWidget(svgAssetPath: AppIcons.appIcons);
    } else if (titleWidget != null) {
      return titleWidget;
    } else if (title != null) {
      return Text(title!);
    }
    return null;
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    } else if (onBackPressed != null && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: onBackPressed,
      );
    }
    return null;
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  // ================== Transparent appbar ================
  // extendBodyBehindAppBar: true,
  // AppBar(
  //     backgroundColor: Colors.transparent,
  //     surfaceTintColor: Colors.transparent,
  //     systemOverlayStyle: SystemUiOverlayStyle(
  //         statusBarColor: Colors.transparent,
  //         statusBarIconBrightness: Brightness.dark
  //     ),
}
