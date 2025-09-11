import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_screenutil/flutter_screenutil.dart';


// Method 1: Extract and display the embedded base64 image directly
class ExtractBase64ImageWidget extends StatefulWidget {
  final String svgAssetPath; // Path to your SVG in assets folder

  const ExtractBase64ImageWidget({
    super.key,
    required this.svgAssetPath,
  });

  @override
  _ExtractBase64ImageWidgetState createState() => _ExtractBase64ImageWidgetState();
}

class _ExtractBase64ImageWidgetState extends State<ExtractBase64ImageWidget> {
  Uint8List? imageBytes;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAndExtractImage();
  }

  Future<void> _loadAndExtractImage() async {
    try {
      // Load SVG content from assets
      final String svgContent = await DefaultAssetBundle.of(context).loadString(widget.svgAssetPath);

      // Extract base64 string from the SVG
      // Pattern to find base64 in xlink:href attribute
      final RegExp regExp = RegExp(
        r'xlink:href="data:image/[^;]+;base64,([^"]+)"',
        multiLine: true,
        dotAll: true,
      );

      final Match? match = regExp.firstMatch(svgContent);

      if (match != null) {
        String base64String = match.group(1)!;

        // Clean the base64 string (remove any whitespace or line breaks)
        base64String = base64String.replaceAll(RegExp(r'\s'), '');

        // Decode to bytes
        final Uint8List bytes = base64Decode(base64String);

        setState(() {
          imageBytes = bytes;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No base64 image found in SVG';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading image: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CupertinoActivityIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }
    if (imageBytes != null) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Image.memory(
          imageBytes!,
          fit: BoxFit.contain,
          height: 36.h,
          width: 66.w,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text('Error displaying image'),
            );
          },
        ),
      );
    }

    return Center(child: Text('No image to display'));
  }
}