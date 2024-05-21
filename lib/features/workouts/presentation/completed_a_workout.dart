import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';
import 'package:trainer_app/features/workouts/data/workouts_repository.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';
import 'package:trainer_app/features/workouts/domain/set.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';
import 'package:trainer_app/features/workouts/presentation/workout_card.dart';
import 'package:trainer_app/features/workouts/presentation/workout_providers.dart';

class CompleteAWorkout extends ConsumerStatefulWidget {
  const CompleteAWorkout({
    super.key,
    required this.plan,
  });
  final Plan plan;

  @override
  ConsumerState<CompleteAWorkout> createState() => _CompletedWorkoutState();
}

class _CompletedWorkoutState extends ConsumerState<CompleteAWorkout> {
  int reps = 0;
  int weight = 0;

  void saveCompletedWorkoutToFirestore() {
    final workoutsToSave = ref.read(completedWorkoutProvider);
    final userId = ref.read(authRepositoryProvider).currentUser!.uid;
    final workoutRepository = ref.read(workoutsRepositoryProvider);

    workoutRepository.addCompletedWorkout(userId, workoutsToSave);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final completedWorkouts =
        await convertToCompletedWorkout(widget.plan.workouts);
    await Future.delayed(Duration.zero);
    ref
        .read(completedWorkoutProvider.notifier)
        .update((state) => completedWorkouts);
  }

  Future<List<CompletedWorkout>> convertToCompletedWorkout(
      List<Workout> workouts) async {
    List<CompletedWorkout> completedWorkouts = [];

    await Future.forEach(workouts, (Workout w) async {
      int id = await ref.read(workoutsRepositoryProvider).generateUniqueId();

      List<WorkoutSet> workoutSets = [];
      for (int i = 0; i < w.sets; i++) {
        workoutSets.add(WorkoutSet(number: i, reps: 0, weight: 0));
      }
      completedWorkouts.add(
        CompletedWorkout(
          id: id,
          workoutId: w.id,
          workoutSets: workoutSets,
          name: w.name,
        ),
      );
    });

    return completedWorkouts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fill in your session'), actions: [
        Padding(
          padding:
              const EdgeInsets.only(right: 10.0), // Adjust the value as needed
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // Background color of the circle
            ),
            child: IconButton(
              onPressed: () {
                saveCompletedWorkoutToFirestore();
                GoRouter.of(context).go('/plans');
              },
              icon: const Icon(Icons.check, color: Colors.green, size: 24),
            ), // Icon inside the circle
          ),
        ),
      ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Complete your workout!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            ...widget.plan.workouts.map((w) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  WorkoutCard(
                    w: w,
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

