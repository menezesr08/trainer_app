import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trainer_app/features/user/domain/app_user.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';

double calculateBeginner(double bodyweight) {
  return 0.7 * bodyweight + 5;
}

double calculateNovice(double bodyweight) {
  return 1.5 * bodyweight + 28;
}

double calculateIntermediate(double bodyweight) {
  return 2.5 * bodyweight + 7;
}

double calculateAdvanced(double bodyweight) {
  return 3.2 * bodyweight - 1;
}

List<ChartData> generateStandardLineData(
    double value, DateTime startDate, DateTime endDate) {
  return [
    ChartData(startDate, value),
    ChartData(endDate, value),
  ];
}

class ChartData {
  final DateTime x;
  final double y;

  ChartData(this.x, this.y);
}

class Graph extends StatefulWidget {
  const Graph({
    super.key,
    required this.cw,
    required this.user,
  });
  final List<CompletedWorkout> cw;
  final AppUser user;

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
        textStyle:
            TextStyle(fontSize: 12), // Reduce the font size for better fit
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Weight (kg)'),
      ),
      series: <ChartSeries>[
        LineSeries<CompletedWorkout, DateTime>(
          dataSource: widget.cw,
          xValueMapper: (CompletedWorkout cw, _) => cw.completedAt,
          yValueMapper: (CompletedWorkout cw, _) => cw.averageWeight,
          name: 'User Average Weight',
          color: Colors.purple,
          width: 2,
          markerSettings: MarkerSettings(
            isVisible: true,
            color: Colors.purple,
            borderWidth: 1,
            shape: DataMarkerType.circle,
            borderColor: Colors.purple,
          ),
        ),
      ],
    );
  }
}
