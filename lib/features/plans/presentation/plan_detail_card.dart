import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

class PlanDetailCard extends StatelessWidget {
  const PlanDetailCard({super.key, required this.w});
  final Workout w;

  @override
  Widget build(BuildContext context) {
    return Row(
        textBaseline: TextBaseline.ideographic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          const SizedBox(
            width: 25,
          ),
          Text(
            w.name,
            style: const TextStyle(
                color: FlexColor.purpleBrownDarkSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            '${w.sets} x ${w.reps}',
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '${w.weight} kg',
            style: TextStyle(color: FlexColor.goldDarkSecondaryContainer),
          ),
        ]);
  }
}
