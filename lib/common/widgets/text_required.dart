import 'package:flutter/material.dart';

class TextRequired extends StatelessWidget {
  const TextRequired({
    super.key, required this.text, this.textStyle,
  });
  final String text;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: textStyle??const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const TextSpan(
            text: '*',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ],
      ),
    );
  }
}