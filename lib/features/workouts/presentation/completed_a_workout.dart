import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';
import 'package:trainer_app/features/workouts/data/workouts_repository.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';
import 'package:trainer_app/features/workouts/domain/set.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';
import 'package:trainer_app/features/workouts/presentation/workout_card.dart';
import 'package:trainer_app/features/workouts/presentation/workout_providers.dart';
import 'package:trainer_app/providers/user_providers.dart';

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
    final userId = ref.watch(userIdProvider);
    final workoutRepository = ref.read(workoutsRepositoryProvider);

    workoutRepository.addCompletedWorkout(userId!, workoutsToSave);
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
            completedAt: DateTime.now(),
            planName: widget.plan.name),
      );
    });

    return completedWorkouts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Fill in your session',
            style: TextStyle(color: FlexColor.purpleBrownDarkSecondary),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 10.0), // Adjust the value as needed
              child: IconButton(
                onPressed: () {
                  saveCompletedWorkoutToFirestore();
                  GoRouter.of(context).go('/plans');
                },
                icon: const Icon(Icons.check,
                    color: FlexColor.purpleBrownDarkPrimary, size: 24),
              ),
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
