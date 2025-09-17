import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';

class TermsPrivacyWidget extends StatelessWidget {
  // Required callbacks
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  // Customizable text
  final String prefixText;
  final String termsText;
  final String privacyText;
  final String separatorText;

  // Styling options
  final Color? primaryColor;
  final Color? baseTextColor;
  final double? fontSize;
  final TextAlign? textAlign;
  final bool showUnderline;
  final FontWeight? linkFontWeight;
  final EdgeInsets? padding;

  const TermsPrivacyWidget({
    super.key,
    this.onTermsTap,
    this.onPrivacyTap,
    this.prefixText = 'By signing up, you agree to our ',
    this.termsText = 'Terms of Service',
    this.privacyText = 'Privacy Policy',
    this.separatorText = ' and ',
    this.primaryColor,
    this.baseTextColor,
    this.fontSize,
    this.textAlign = TextAlign.center,
    this.showUnderline = true,
    this.linkFontWeight,
    this.padding,
  });

  // Factory constructors for common use cases
  factory TermsPrivacyWidget.signUp({
    required VoidCallback onTermsTap,
    required VoidCallback onPrivacyTap,
    Color? primaryColor,
  }) {
    return TermsPrivacyWidget(
      onTermsTap: onTermsTap,
      onPrivacyTap: onPrivacyTap,
      prefixText: 'By signing up, you agree to our ',
      primaryColor: primaryColor,
    );
  }

  factory TermsPrivacyWidget.signIn({
    required VoidCallback onTermsTap,
    required VoidCallback onPrivacyTap,
    Color? primaryColor,
  }) {
    return TermsPrivacyWidget(
      onTermsTap: onTermsTap,
      onPrivacyTap: onPrivacyTap,
      prefixText: 'By signing in, you agree to our ',
      primaryColor: primaryColor,
    );
  }

  factory TermsPrivacyWidget.continuing({
    required VoidCallback onTermsTap,
    required VoidCallback onPrivacyTap,
    Color? primaryColor,
  }) {
    return TermsPrivacyWidget(
      onTermsTap: onTermsTap,
      onPrivacyTap: onPrivacyTap,
      prefixText: 'By continuing, you agree to our ',
      primaryColor: primaryColor,
    );
  }

  factory TermsPrivacyWidget.simple({
    required VoidCallback onTermsTap,
    required VoidCallback onPrivacyTap,
    Color? primaryColor,
  }) {
    return TermsPrivacyWidget(
      onTermsTap: onTermsTap,
      onPrivacyTap: onPrivacyTap,
      prefixText: '',
      separatorText: ' • ',
      primaryColor: primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final linkColor = primaryColor ?? const Color(0xFF4CAF50);
    final textColor = baseTextColor ?? Colors.grey[500];
    final textSize = fontSize ?? 12.sp;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Center(
        child: RichText(
          textAlign: textAlign ?? TextAlign.center,
          text: TextSpan(
            style: GoogleFontStyles.h6(
              color: textColor,
            ),
            children: [
              if (prefixText.isNotEmpty)
                TextSpan(text: prefixText),
              TextSpan(
                text: termsText,
                style: GoogleFontStyles.customSize(
                  size: textSize,
                  color: linkColor,
                  fontWeight: linkFontWeight,
                  underline: showUnderline ? TextDecoration.underline : null,
                  underlineColor: showUnderline ? linkColor : null,
                ),
                recognizer: onTermsTap != null
                    ? (TapGestureRecognizer()..onTap = onTermsTap)
                    : null,
              ),
              TextSpan(text: separatorText),
              TextSpan(
                text: privacyText,
                style: GoogleFontStyles.customSize(
                  size: textSize,
                  color: linkColor,
                  fontWeight: linkFontWeight,
                  underline: showUnderline ? TextDecoration.underline : null,
                  underlineColor: showUnderline ? linkColor : null,
                ),
                recognizer: onPrivacyTap != null
                    ? (TapGestureRecognizer()..onTap = onPrivacyTap)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}