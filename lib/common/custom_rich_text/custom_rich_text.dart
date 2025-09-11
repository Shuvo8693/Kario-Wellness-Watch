import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../app_text_style/google_app_style.dart';
import '../app_text_style/google_styles.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    required this.normalText,
    required this.clickableTexts,
    this.normalTextStyle,
    this.clickableTextStyle,
    this.onTapCallbacks,
    this.maxLines,
  });

  final String normalText;
  final List<String> clickableTexts;
  final TextStyle? normalTextStyle;
  final TextStyle? clickableTextStyle;
  final List<VoidCallback?>? onTapCallbacks;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];
    String remainingText = normalText;

    for (int i = 0; i < clickableTexts.length; i++) {
      String clickableText = clickableTexts[i];
      int index = remainingText.indexOf(clickableText); // ===> find the index of clickable Text positions

      print(remainingText); // first iteration will show full text and Second iteration will show remaining text after eliminate first portion of text.

      if (index != -1) {
        // Add text before clickable text
        if (index > 0) {
          spans.add(TextSpan(
            text: remainingText.substring(0, index), // Show text 0 to clickable Text index position
            style: normalTextStyle ?? const TextStyle(fontSize: 16, color: Colors.black),
          ));
          print(remainingText);
          print(spans);
        }

        // Add clickable text
        spans.add( TextSpan(
          text: clickableText,
          style: clickableTextStyle ?? const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = onTapCallbacks != null && i < onTapCallbacks!.length
                ? onTapCallbacks![i]
                : null,
          ),
        );
        print(clickableText.length);
        // Update remaining text
        remainingText = remainingText.substring(index + clickableText.length); //<==== Eliminate or substring to the first privacy policy text.
        print(remainingText); //<=== remaining text will be here
      }
    }

    // Add any remaining text
    if (remainingText.isNotEmpty) {
      spans.add(TextSpan(
        text: remainingText,
        style: normalTextStyle ?? const TextStyle(fontSize: 16, color: Colors.black),
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
      style: const TextStyle(overflow: TextOverflow.ellipsis),
    );
  }
}

// Usage example for your specific case:
class TermsAndConditionsWidget extends StatelessWidget {
  const TermsAndConditionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomRichText(
        normalText: "By continuing, I agree that Rydr may collect, use, and share the information I provide in accordance with the Privacy Policy. I also confirm that I have read, understood, and agree to the Terms & Conditions",
        clickableTexts: ["Privacy Policy", "Terms & Conditions"],
        normalTextStyle: GoogleFontStyles.h6(
          color: Colors.white,
          height: 1.5,
        ),
        clickableTextStyle: GoogleFontStyles.h6(
          color: Colors.blue,
          height: 1.5,
        ),
        onTapCallbacks: [
              () {
            // Handle Privacy Policy tap
            print("Privacy Policy tapped");
            // Navigate to privacy policy or open URL
          },
              () {
            // Handle Terms & Conditions tap
            print("Terms & Conditions tapped");
            // Navigate to terms or open URL
          },
        ],
      ),
    );
  }
}