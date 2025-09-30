

class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}

class HealthMetricConfig {
  final String title;
  final String unit;
  final String totalLabel;
  final String totalValue;
  final List<ChartData> chartData;
  final DailyStats? dailyStats;
  final String? aboutText;
  final GoalProgress? goalProgress;

  HealthMetricConfig({
    required this.title,
    required this.unit,
    required this.totalLabel,
    required this.totalValue,
    required this.chartData,
    this.dailyStats,
    this.aboutText,
    this.goalProgress,
  });
}

class DailyStats {
  final String value1;
  final String label1;
  final String? value2;
  final String? label2;
  final String? value3;
  final String? label3;

  DailyStats({
    required this.value1,
    required this.label1,
    this.value2,
    this.label2,
    this.value3,
    this.label3,
  });
}

class GoalProgress {
  final double current;
  final double goal;
  final String unit;
  final int achieved;
  final int total;

  GoalProgress({
    required this.current,
    required this.goal,
    required this.unit,
    required this.achieved,
    required this.total,
  });
}