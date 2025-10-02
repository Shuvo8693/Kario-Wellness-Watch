import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';
import 'package:kario_wellness_watch/common/widgets/custom_text_field.dart';




class ManualRecordingDialog extends StatefulWidget {
  final Function(double) onSave;

  const ManualRecordingDialog({super.key, required this.onSave});

  @override
  State<ManualRecordingDialog> createState() => _ManualRecordingDialogState();
}

class _ManualRecordingDialogState extends State<ManualRecordingDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Manual Recording',
              style: GoogleFontStyles.h3(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            CustomTextField(controller: _controller,labelText: 'Blood glucose level (mg/dL)',),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    text: 'Save',
                    onTap: () {
                      final value = double.tryParse(_controller.text);
                      if (value != null) {
                        widget.onSave(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}