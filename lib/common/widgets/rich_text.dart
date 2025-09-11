import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key, required this.text1, this.textStyle1, required this.text2, this.textStyle2,
  });
  final String text1;
  final String text2;
  final TextStyle? textStyle1;
  final TextStyle? textStyle2;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      maxLines: 2,
      TextSpan(
        style: TextStyle(overflow: TextOverflow.ellipsis),
        children: [
          TextSpan(
            text: text1,
            style: textStyle1??const TextStyle(fontSize: 16, color: Colors.black,overflow: TextOverflow.ellipsis),
          ),
           const TextSpan(text: ' '),
           TextSpan(
            text: text2,
            style: textStyle2??const TextStyle(fontSize: 16, color: Colors.grey,overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}