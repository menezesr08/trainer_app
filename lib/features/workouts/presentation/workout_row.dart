import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/common_widgets/numeric_input_field.dart';
import 'package:trainer_app/features/workouts/domain/set.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';
import 'package:trainer_app/features/workouts/extensions.dart';
import 'package:trainer_app/features/workouts/presentation/workout_providers.dart';

class WorkoutRow extends ConsumerStatefulWidget {
  const WorkoutRow({super.key, required this.setNumber, required this.w});
  final int setNumber;
  final Workout w;

  @override
  ConsumerState<WorkoutRow> createState() => _ConsumerWorkoutRowState();
}

class _ConsumerWorkoutRowState extends ConsumerState<WorkoutRow> {
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

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
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      const SizedBox(
        width: 8,
      ),
      Text(
        '${widget.setNumber}',
        style: const TextStyle(color: Colors.white),
      ),
      const SizedBox(
        width: 18,
      ),
      SizedBox(
        width: 48,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple.withOpacity(0.9), width: 2),
            borderRadius:
                BorderRadius.circular(8.0), // Optional: Add rounded corners
          ),
          child: NumericInputField(
            controller: _repsController,
            callback: (value) {
              setState(() {
                reps = int.tryParse(value) ?? 0;
                updateSetProperty(
                  widget.setNumber,
                  widget.w.id,
                  'reps',
                  reps,
                );
              });
            },
          ),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      const Text(
        'Reps',
        style: TextStyle(
            color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        width: 10,
      ),
      SizedBox(
        width: 48,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple.withOpacity(0.9), width: 2),
            borderRadius:
                BorderRadius.circular(8.0), // Optional: Add rounded corners
          ),
          child: NumericInputField(
            controller: _weightController,
            callback: (value) {
              setState(() {
                weight = int.tryParse(value) ?? 0;
                updateSetProperty(
                  widget.setNumber,
                  widget.w.id,
                  'weight',
                  weight,
                );
              });
            },
          ),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      const Text(
        'Weight',
        style: TextStyle(
            color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        width: 10,
      ),
    ]);
  }
}
