import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HaveAnAccountText extends StatelessWidget {
  final String normalText;
  final String clickableText;
  final VoidCallback? onTap;
  final TextStyle? normalTextStyle;
  final TextStyle? clickableTextStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const HaveAnAccountText({
    super.key,
    required this.normalText,
    required this.clickableText,
    this.onTap,
    this.normalTextStyle,
    this.clickableTextStyle,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(
        style: normalTextStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
        children: [
          TextSpan(text: normalText),
          TextSpan(
            text: clickableText,
            style: clickableTextStyle ??
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4CAF50),
                ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}