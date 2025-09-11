import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SeeMoreText extends StatefulWidget {
  const SeeMoreText({super.key, required this.text, this.style, this.characterLimit = 200});

  final String text;
  final TextStyle? style;
 final int characterLimit;

  @override
  State<SeeMoreText> createState() => _SeeMoreTextState();
}

class _SeeMoreTextState extends State<SeeMoreText> {
  bool _isExpanded = false;


  @override
  Widget build(BuildContext context) {
    bool isTextOverFlow = widget.text.length > widget.characterLimit;
    String displayedText = _isExpanded || !isTextOverFlow  /// if (isTextOverFlow) is true then !isTextOverFlow will be false for hide bigger text , and if (isTextOverFlow) is false then !isTextOverFlow  will be true for show small text
        ? widget.text
        : "${widget.text.substring(0, widget.characterLimit)}...";

    return RichText(
      text: TextSpan(children: [
        TextSpan(text: displayedText,style:widget.style ?? const TextStyle(color: Colors.black)),
        if (isTextOverFlow) ...[ // if isTextOverFlow is true then see more button will show
          const TextSpan(text: '  '),
          TextSpan(
            text: _isExpanded ? 'SeeLess' : 'SeeMore',
            style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700),
            recognizer: TapGestureRecognizer()..onTap = () {
              setState(() {
                _isExpanded =! _isExpanded;
              });
            },
          )
        ]
      ]),
    );
  }
}

/// if i don't use spread operator
/*List<TextSpan> textSpans = [
  TextSpan(text: displayedText),
];
if (isTextOverFlow) {
  textSpans.add(
    TextSpan(
      text: _isExpanded ? " See Less" : " See More",
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
    ),
  );
}
return RichText(text: TextSpan(children: textSpans));
*/
