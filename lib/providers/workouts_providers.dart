import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/workouts/data/workouts_repository.dart';
import 'package:trainer_app/features/workouts/domain/base_workout.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';
import 'package:trainer_app/providers/auth_providers.dart';
part 'workouts_providers.g.dart';

@Riverpod(keepAlive: true)
Future<List<BaseWorkout>> baseWorkouts(BaseWorkoutsRef ref) async {
  final workoutsRepository = ref.read(workoutsRepositoryProvider);
  return workoutsRepository.getBaseWorkouts();
}

@Riverpod(keepAlive: true)
Stream<List<CompletedWorkout>> completedWorkouts(CompletedWorkoutsRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userId = authRepository.currentUser!.uid;
  final workoutsRepository = ref.read(workoutsRepositoryProvider);
  return workoutsRepository.getCompletedWorkoutsFromFirestore(userId);
}

@Riverpod(keepAlive: true)
WorkoutsRepository workoutsRepository(WorkoutsRepositoryRef ref) {
  return WorkoutsRepository();
}
