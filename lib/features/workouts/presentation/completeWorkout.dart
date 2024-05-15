import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/common_widgets/numeric_input_field.dart';
import 'package:trainer_app/constants/colors.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';
import 'package:trainer_app/features/workouts/data/workouts_repository.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';
import 'package:trainer_app/features/workouts/domain/set.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';
import 'package:trainer_app/features/workouts/extensions.dart';
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
        CompletedWorkout(id: id, workoutId: w.id, workoutSets: workoutSets),
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.withOpacity(0.9),
              Colors.black.withOpacity(0.9), // Adjust opacity as needed
              // Adjust opacity as needed
            ],
            stops: const [0.0, 0.5],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20)),
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
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ...[
                      for (var i = 0; i < widget.w.sets; i++)
                        WorkoutRow(setNumber: i + 1, w: widget.w)
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
