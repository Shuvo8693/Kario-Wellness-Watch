
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/manual_recording.dart';
import 'package:kario_wellness_watch/app/modules/blood_glucose/widgets/periodic_selector.dart';
import 'package:kario_wellness_watch/app/modules/weight_analysis/widgets/manual_weight_recording_dialouge.dart';
import 'package:kario_wellness_watch/app/modules/weight_analysis/widgets/weight_analysis_card.dart';
import 'package:kario_wellness_watch/app/modules/weight_analysis/widgets/weight_change_gauge.dart';
import 'package:kario_wellness_watch/app/modules/weight_analysis/widgets/weight_chart.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:kario_wellness_watch/common/widgets/custom_button.dart';


class WeightAnalysisView extends StatefulWidget {
  const WeightAnalysisView({super.key});

  @override
  State<WeightAnalysisView> createState() => _WeightAnalysisViewState();
}

class _WeightAnalysisViewState extends State<WeightAnalysisView> {
  final String _selectedPeriod = 'Day';
  double _currentWeight = 145.5;
  double _bmi = 22.1;
  final double _targetWeight = 138.1;

  final List<ChartData> _weightTrendData = [
    ChartData('2024/7/20', 148),
    ChartData('2025/03/01', 145.5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Weight',
          style: GoogleFontStyles.h3(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            PeriodSelector(selectedPeriod: _selectedPeriod),

            // Weight Analysis Card
            WeightAnalysisCard(bmi: _bmi, targetWeight: _targetWeight),

            // Weight Change Info
            WeightChangeGauge(currentWeight: _currentWeight),

            // Trend Section
            WeightChart(weightTrendData: _weightTrendData),


            // Manual Recording Button
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CustomButton(
                text: 'Manual recording',
                onTap: () {
                  _showManualRecordingDialog();
                },
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showManualRecordingDialog() {
    showDialog(
      context: context,
      builder: (context) => ManualWeightRecordingDialog(
        onSave: (value) {
          setState(() {
            _currentWeight = value;
            // Recalculate BMI (simplified formula)
            _bmi = (value / 2.205) / ((1.75 * 1.75));
          });
        },
      ),
    );
  }
}


