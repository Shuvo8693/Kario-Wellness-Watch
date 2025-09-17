import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../app_text_style/google_app_style.dart';


class DontHaveAnAccount extends StatelessWidget {
  final VoidCallback onTap;
  const DontHaveAnAccount({
    super.key, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: GoogleFontStyles.h5(
            color: Colors.grey[600],
          ),
          children: [
            TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: 'Sign up',
              style: GoogleFontStyles.h5(
                fontWeight: FontWeight.w600,
                color: Color(0xFF4CAF50),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}