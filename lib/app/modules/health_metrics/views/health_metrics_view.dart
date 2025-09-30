
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/model/healths_metris_model.dart';
import 'package:kario_wellness_watch/common/app_text_style/google_app_style.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum HealthMetricType {
  heartRate,
  steps,
  distance,
  calories,
  sleep,
  bloodOxygen,
  skinTemperature,
}

class HealthMetricsView extends StatefulWidget {
  final HealthMetricType metricType;

  const HealthMetricsView({
    super.key,
    required this.metricType,
  });

  @override
  State<HealthMetricsView> createState() => _HealthMetricsViewState();
}

class _HealthMetricsViewState extends State<HealthMetricsView> {
  String _selectedPeriod = 'Day';
  String _selectedDate = '2025/7/26';

  HealthMetricConfig get config => _getConfig(widget.metricType);

  HealthMetricConfig _getConfig(HealthMetricType type) {
    switch (type) {
      case HealthMetricType.heartRate:
        return HealthMetricConfig(
          title: 'Heart rate',
          unit: 'bpm',
          totalLabel: 'Total',
          totalValue: '84',
          chartData: [
            ChartData('00:00', 70),
            ChartData('06:00', 75),
            ChartData('12:00', 89),
            ChartData('18:00', 82),
            ChartData('24:00', 78),
          ],
          dailyStats: DailyStats(value1: '79', label1: 'Lowest', value2: '84', label2: 'Highest', value3: '81', label3: 'Average'),
          aboutText: 'Heart rate is the number of heartbeats per minute, usually expressed as "bpm". It\'s influenced by physical activity, emotions, and medications. Wearing the device to Monitor heart rate helps understand your cardiac status.',
          goalProgress: null,
        );

      case HealthMetricType.steps:
        return HealthMetricConfig(
          title: 'Step',
          unit: 'steps',
          totalLabel: 'Total steps',
          totalValue: '29',
          chartData: [
            ChartData('Mon', 500),
            ChartData('Tue', 800),
            ChartData('Wed', 1200),
            ChartData('Thu', 600),
            ChartData('Fri', 900),
            ChartData('Sat', 1500),
            ChartData('Sun', 700),
          ],
          dailyStats: null,
          aboutText: null,
          goalProgress: GoalProgress(current: 0.01, goal: 10000, unit: 'steps', achieved: 6, total: 7),
        );

      case HealthMetricType.distance:
        return HealthMetricConfig(
          title: 'Distance',
          unit: 'miles',
          totalLabel: 'Total distance',
          totalValue: '0.01',
          chartData: [
            ChartData('Mon', 0.5),
            ChartData('Tue', 1.2),
            ChartData('Wed', 0.8),
            ChartData('Thu', 1.5),
            ChartData('Fri', 0.3),
            ChartData('Sat', 2.1),
            ChartData('Sun', 0.7),
          ],
          dailyStats: DailyStats(value1: '0.01', label1: 'Total', value2: '0.00', label2: 'Daily average', value3: null, label3: null),
          aboutText: null,
          goalProgress: GoalProgress(current: 0.01, goal: 0.20, unit: 'miles', achieved: 0, total: 7),
        );

      case HealthMetricType.calories:
        return HealthMetricConfig(
          title: 'Calories',
          unit: 'kcal',
          totalLabel: 'Total calories',
          totalValue: '1',
          chartData: [
            ChartData('Mon', 100),
            ChartData('Tue', 150),
            ChartData('Wed', 120),
            ChartData('Thu', 180),
            ChartData('Fri', 90),
            ChartData('Sat', 200),
            ChartData('Sun', 110),
          ],
          dailyStats: DailyStats(value1: '1', label1: 'Total', value2: '0', label2: 'Daily average', value3: null, label3: null),
          aboutText: null,
          goalProgress: GoalProgress(current: 1, goal: 499, unit: 'kcal', achieved: 0, total: 7),
        );

      case HealthMetricType.sleep:
        return HealthMetricConfig(
          title: 'Sleep',
          unit: 'hrs',
          totalLabel: 'Sleep trend',
          totalValue: '56',
          chartData: [
            ChartData('Mon', 7),
            ChartData('Tue', 6.5),
            ChartData('Wed', 8),
            ChartData('Thu', 7.5),
            ChartData('Fri', 6),
            ChartData('Sat', 8.5),
            ChartData('Sun', 7),
          ],
          dailyStats: null,
          aboutText: 'To track your sleep patterns, simply wear your device to bed.\n\nOnce synced with your device, the app will record and analyze your sleep stages to help you improve your sleep quality and ensure adequate rest.\n\nNote: This device focuses on tracking nighttime sleep, to singullar sleep schedules who tend to sleep accurate sleep data.',
          goalProgress: null,
        );

      case HealthMetricType.bloodOxygen:
        return HealthMetricConfig(
          title: 'Blood oxygen',
          unit: '%',
          totalLabel: 'Total',
          totalValue: '97',
          chartData: [
            ChartData('00:00', 96),
            ChartData('06:00', 95),
            ChartData('12:00', 97),
            ChartData('18:00', 98),
            ChartData('24:00', 97),
          ],
          dailyStats: DailyStats(value1: '97', label1: 'Lowest', value2: '97', label2: 'Highest', value3: '97', label3: 'Average'),
          aboutText: 'Blood oxygen (SpO2) is the concentration of oxygen in your blood. It\'s an important indicator of your respiratory function and overall health status.',
          goalProgress: null,
        );

      case HealthMetricType.skinTemperature:
        return HealthMetricConfig(
          title: 'Skin temperature',
          unit: '°C',
          totalLabel: 'Average temperature',
          totalValue: '36.5',
          chartData: [
            ChartData('00:00', 36.2),
            ChartData('06:00', 36.0),
            ChartData('12:00', 36.8),
            ChartData('18:00', 36.6),
            ChartData('24:00', 36.3),
          ],
          dailyStats: DailyStats(value1: '36.0', label1: 'Lowest', value2: '36.8', label2: 'Highest', value3: '36.5', label3: 'Average'),
          aboutText: 'Skin temperature monitoring helps track your body\'s thermal regulation. Normal skin temperature ranges from 32°C to 37°C and can be affected by activity, environment, and health conditions.',
          goalProgress: null,
        );
    }
  }

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
          config.title,
          style: GoogleFontStyles.h3(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.metricType == HealthMetricType.distance)
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: DropdownButton<String>(
                value: _selectedDate,
                underline: SizedBox(),
                items: ['2025/7/26', '2025/7/25', '2025/7/24']
                    .map((date) => DropdownMenuItem(value: date, child: Text(date)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedDate = value);
                },
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Period Selector
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: ['Day', 'Week', 'Month'].map((period) {
                  final isSelected = _selectedPeriod == period;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPeriod = period),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.grey[300] : Colors.transparent,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          period,
                          textAlign: TextAlign.center,
                          style: GoogleFontStyles.h5(
                            color: Colors.black87,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Chart Card
            ChartCard(config: config),

            SizedBox(height: 16.h),

            // Daily Statistics
            if (config.dailyStats != null)
              DailyStatistics(selectedPeriod: _selectedPeriod, config: config),

            // Goal Progress
            if (config.goalProgress != null)
              GoalProgressWidgets(config: config),

            // About Section
            if (config.aboutText != null)
              AboutSection(config: config),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }


}

class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.config,
  });

  final HealthMetricConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(config.totalLabel,
            style: GoogleFontStyles.h5(color: Colors.black54),
          ),
          SizedBox(height: 4.h),
          Text('${config.totalValue} ${config.unit}',
            style: GoogleFontStyles.h2(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),
    
          // Syncfusion Chart
          SizedBox(
            height: 180.h,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                axisLine: AxisLine(width: 1,dashArray: [2]),
              ),
              primaryYAxis: NumericAxis(
                isVisible: false,
              ),
              series: [
                SplineSeries<ChartData, String>(
                  dataSource: config.chartData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: Colors.cyan,
                  width: 2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: Colors.cyan,
                    borderColor: Colors.cyan,
                    borderWidth: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DailyStatistics extends StatelessWidget {
  const DailyStatistics({
    super.key,
    required String selectedPeriod,
    required this.config,
  }) : _selectedPeriod = selectedPeriod;

  final String _selectedPeriod;
  final HealthMetricConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedPeriod == 'Week' ? 'Weekly statistics' : 'Daily statistics',
            style: GoogleFontStyles.h4(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
             _buildStatItem(config.dailyStats!.value1, config.dailyStats!.label1, config.unit),
              if (config.dailyStats!.value2 != null)
                _buildStatItem(config.dailyStats!.value2!, config.dailyStats!.label2!, config.unit),
              if (config.dailyStats!.value3 != null)
                _buildStatItem(config.dailyStats!.value3!, config.dailyStats!.label3!, config.unit),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildStatItem(String value, String label, String unit) {
    return Column(
      children: [
        Text(
          '$value $unit',
          style: GoogleFontStyles.h3(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFontStyles.h6(color: Colors.black54),
        ),
      ],
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
    required this.config,
  });

  final HealthMetricConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${config.title.toLowerCase()}',
            style: GoogleFontStyles.h4(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            config.aboutText!,
            style: GoogleFontStyles.h6(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class GoalProgressWidgets extends StatelessWidget {
  const GoalProgressWidgets({
    super.key,
    required this.config,
  });

  final HealthMetricConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Goal progress',
            style: GoogleFontStyles.h4(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '${config.goalProgress!.current} ${config.goalProgress!.unit}',
            style: GoogleFontStyles.h2(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Only ${config.goalProgress!.goal - config.goalProgress!.current} ${config.goalProgress!.unit} to reach the goal',
            style: GoogleFontStyles.h6(color: Colors.black54),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'Days to reach goal',
                style: GoogleFontStyles.h6(color: Colors.black54),
              ),
              Spacer(),
              Text(
                '${config.goalProgress!.achieved}/${config.goalProgress!.total}',
                style: GoogleFontStyles.h5(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

