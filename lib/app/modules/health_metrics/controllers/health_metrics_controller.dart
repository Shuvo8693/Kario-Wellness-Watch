import 'package:get/get.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/model/healths_metris_model.dart';
import 'package:kario_wellness_watch/app/modules/health_metrics/views/health_metrics_view.dart';

class HealthMetricsController extends GetxController {

  HealthMetricConfig getConfig(HealthMetricType type) {
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
}
