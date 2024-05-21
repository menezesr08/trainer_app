import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/insights/presentation/graph.dart';
import 'package:trainer_app/features/workouts/domain/base_workout.dart';

class IndividualWorkoutInsights extends ConsumerStatefulWidget {
  const IndividualWorkoutInsights({super.key, required this.w});
  final BaseWorkout w;

  @override
  ConsumerState<IndividualWorkoutInsights> createState() =>
      _ConsumerIndividualWorkoutInsightsState();
}

class _ConsumerIndividualWorkoutInsightsState
    extends ConsumerState<IndividualWorkoutInsights> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            widget.w.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        LineChartSample2()
      ],
    );
  }
}
