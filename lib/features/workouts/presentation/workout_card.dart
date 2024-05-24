import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/workouts/domain/set.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';
import 'package:trainer_app/features/workouts/extensions.dart';
import 'package:trainer_app/features/workouts/presentation/workout_providers.dart';
import 'package:trainer_app/features/workouts/presentation/workout_row.dart';

class WorkoutCard extends ConsumerStatefulWidget {
  const WorkoutCard({super.key, required this.w});
  final Workout w;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputWorkoutState();
}

class _InputWorkoutState extends ConsumerState<WorkoutCard> {
  int reps = 0;
  int weight = 0;
  void updateSetProperty(
      int setNumber, int workoutId, String propertyName, dynamic value) {
    ref.read(completedWorkoutProvider.notifier).update((state) {
      return state.map((completedWorkout) {
        if (completedWorkout.workoutId == workoutId) {
          final updatedSets = completedWorkout.workoutSets
              .map((set) {
                if (set.number == setNumber) {
                  return set.copyWithProperty(propertyName, value);
                } else {
                  return set;
                }
              })
              .whereType<WorkoutSet>()
              .toList();
          return completedWorkout.copyWith(workoutSets: updatedSets);
        }
        return completedWorkout;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: FlexColor.purpleBrownDarkSecondary, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.w.name,
                        style: const TextStyle(
                            color: FlexColor.purpleBrownDarkSecondary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ...[
                      for (var i = 0; i < widget.w.sets; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: WorkoutRow(setNumber: i, w: widget.w),
                        )
                    ],
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
