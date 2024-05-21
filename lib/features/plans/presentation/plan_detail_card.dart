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
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            '${w.sets} sets  ${w.reps} reps  ${w.weight} weight',
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ]);
  }
}