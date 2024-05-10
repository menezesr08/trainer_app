import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/common_widgets/numeric_input_field.dart';
import 'package:trainer_app/constants/colors.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/plans/data/plan_repository.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';
import 'package:trainer_app/features/plans/presentation/plans_providers.dart';
import 'package:trainer_app/features/workouts/domain/base_workout.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';
import 'package:trainer_app/features/workouts/extensions.dart';

class PlanDetails extends ConsumerStatefulWidget {
  const PlanDetails({super.key, required this.planName});
  final String planName;

  @override
  ConsumerState<PlanDetails> createState() => _PlanDetailsState();
}

class _PlanDetailsState extends ConsumerState<PlanDetails> {
  void savePlanToFirestore() {
    final workoutsToSave = ref.read(updatedWorkoutsForPlan);
    final userId = ref.read(authRepositoryProvider).currentUser!.uid;
    final planRepository = ref.read(planRepositoryProvider);

    Plan newPlan = Plan(name: widget.planName, workouts: workoutsToSave);

    planRepository.addPlanToFirestore(userId, newPlan);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  List<Workout> convertBaseWorkouts(List<BaseWorkout> baseWorkouts) {
    List<Workout> workouts = baseWorkouts.map((b) {
      return Workout(
        id: b.id,
        name: b.name,
        reps: 0, // Set default value for reps
        sets: 0, // Set default value for sets
        weight: 0, // Set default value for weight
      );
    }).toList();

    return workouts;
  }

  Future<void> _loadData() async {
    final sWorkouts = ref.read(selectedWorkoutsForPlan);
    final workouts = convertBaseWorkouts(sWorkouts);
    await Future.delayed(Duration.zero);
    ref.read(updatedWorkoutsForPlan.notifier).update((state) => workouts);
  }

  @override
  Widget build(BuildContext context) {
    final workouts = ref.read(selectedWorkoutsForPlan);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Give us some more info'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 10.0), // Adjust the value as needed
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Background color of the circle
                  ),
                  child: IconButton(
                    onPressed: () {
                      savePlanToFirestore();
                      GoRouter.of(context).go('/plans');
                    },
                    icon:
                        const Icon(Icons.check, color: Colors.green, size: 24),
                  ), // Icon inside the circle
                ),
              ),
            ]),
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              ...workouts.map((element) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    ExerciseInput(workout: element),
                    // Add SizedBox with desired height between ExerciseInput widgets
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseInput extends ConsumerStatefulWidget {
  const ExerciseInput({
    super.key,
    required this.workout,
  });

  final BaseWorkout workout;

  @override
  ConsumerState<ExerciseInput> createState() => _ExerciseInputState();
}

class _ExerciseInputState extends ConsumerState<ExerciseInput> {
  String name = '';
  int reps = 0;
  int weight = 0;
  int sets = 0;

  void updateWorkoutProperty(
      int workoutId, String propertyName, dynamic value) {
    ref.read(updatedWorkoutsForPlan.notifier).update((state) {
      return state.map((workout) {
        if (workout.id == workoutId) {
          final updatedWorkout = workout.copyWithProperty(propertyName, value);
          return updatedWorkout;
        }
        return workout;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: textColor,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.workout.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Reps'),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: NumericInputField(
                        callback: (value) {
                          setState(() {
                            reps = int.tryParse(value) ?? 0;
                            updateWorkoutProperty(
                                widget.workout.id, 'reps', reps);
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Sets'),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: NumericInputField(
                        callback: (value) {
                          setState(() {
                            sets = int.tryParse(value) ?? 0;
                            updateWorkoutProperty(
                                widget.workout.id, 'sets', sets);
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Weight'),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: NumericInputField(
                        callback: (value) {
                          setState(() {
                            weight = int.tryParse(value) ?? 0;
                            updateWorkoutProperty(
                              widget.workout.id,
                              'weight',
                              weight,
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
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
