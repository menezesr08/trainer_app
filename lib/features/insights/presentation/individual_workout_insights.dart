import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Choose a workout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ],
    );
  }
}
