import 'package:flutter/material.dart';

class MyMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLast;

  const MyMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(title == 'Personal' ? 12.0 : 0),
        topRight: Radius.circular(title == 'Personal' ? 12.0 : 0),
        bottomLeft: Radius.circular(isLast ? 12.0 : 0),
        bottomRight: Radius.circular(isLast ? 12.0 : 0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16.0,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.0,
              color: const Color(0xFF424242),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF212121),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0, // Adjust the font size accordingly
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24.0,
              color: const Color(0xFF9E9E9E),
            ),
          ],
        ),
      ),
    );
  }
}
