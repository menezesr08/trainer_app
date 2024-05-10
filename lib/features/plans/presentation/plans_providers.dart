import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/workouts/domain/base_workout.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

final selectedWorkoutsForPlan = StateProvider<List<BaseWorkout>>((ref) {
  return [];
});

final updatedWorkoutsForPlan = StateProvider<List<Workout>>((ref) {
  return [];
});
