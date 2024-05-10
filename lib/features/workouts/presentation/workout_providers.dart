import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';

final completedWorkoutProvider = StateProvider<List<CompletedWorkout>>((ref) {
  return [];
});