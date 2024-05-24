import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';

class Graph extends StatefulWidget {
  const Graph({super.key, required this.cw});
  final List<CompletedWorkout> cw;

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10), // Optional padding for inner spacing
        decoration: BoxDecoration(
          color: FlexColor.purpleBrownDarkSecondaryContainer,
          border: Border.all(
            color: Colors.black, // Border color
            width: 3, // Border width
          ),
          borderRadius: BorderRadius.circular(15), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: SfCartesianChart(
          backgroundColor: FlexColor.purpleBrownDarkSecondaryContainer,
          plotAreaBackgroundColor: Colors.transparent,
          plotAreaBorderColor: Colors.transparent,
          title: ChartTitle(
            text: 'Average Weight Over Time (kg)',
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            backgroundColor: Colors.transparent,
            borderColor: Colors.grey[300],
            borderWidth: 1,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            intervalType: DateTimeIntervalType.days,
            dateFormat: DateFormat.MMMd(),
            axisLine: AxisLine(
              color: FlexColor.purpleBrownDarkSecondary,
              width: 2,
            ),
            labelStyle: TextStyle(
              color: FlexColor.purpleBrownDarkSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(
                width: 0.5, color: FlexColor.purpleBrownDarkSecondary),
            axisLine: AxisLine(
              color: FlexColor.purpleBrownDarkSecondary,
              width: 2,
            ),
            labelStyle: TextStyle(
              color: FlexColor.purpleBrownDarkSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            color: Colors.black,
            textStyle: TextStyle(
              color: Colors.white,
            ),
            borderWidth: 1,
            borderColor: FlexColor.purpleBrownDarkSecondary,
            duration: 2000,
          ),
          series: <LineSeries<CompletedWorkout, DateTime>>[
            LineSeries<CompletedWorkout, DateTime>(
              dataSource: widget.cw,
              xValueMapper: (CompletedWorkout cw, _) => cw.completedAt,
              yValueMapper: (CompletedWorkout cw, _) => cw.averageWeight,
              name: 'Average Weight',
              color: FlexColor.purpleBrownDarkSecondary,
              width: 2,
              markerSettings: MarkerSettings(
                  isVisible: true,
                  color: FlexColor.purpleBrownDarkSecondary,
                  borderWidth: 2,
                  shape: DataMarkerType.circle,
                  borderColor: FlexColor.purpleBrownDarkSecondary),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
