import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';

class CompletedWorkoutCard extends StatelessWidget {
  const CompletedWorkoutCard({super.key, required this.w});

  final CompletedWorkout w;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                w.name,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                children: [
                  Text(
                    DateFormat('EEE d MMM').format(w.completedAt),
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Text(
                    w.planName,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ...w.workoutSets.map(
          (e) => Row(
              textBaseline: TextBaseline.ideographic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                  child: Text(
                    '${e.number + 1}:    ${e.reps} x  ${e.weight}kg',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ]),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
