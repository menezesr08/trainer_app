import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/common_widgets/numeric_input_field.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';
import 'package:trainer_app/features/plans/presentation/plans_providers.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';
import 'package:trainer_app/features/workouts/extensions.dart';
import 'package:trainer_app/providers/plan_providers.dart';
import 'package:trainer_app/providers/user_providers.dart';

class PlanDetails extends ConsumerStatefulWidget {
  const PlanDetails({
    super.key,
    required this.plan,
  });

  final Plan plan;

  @override
  ConsumerState<PlanDetails> createState() => _PlanDetailsState();
}

class _PlanDetailsState extends ConsumerState<PlanDetails> {
  void savePlanToFirestore() {
    final workoutsToSave = ref.read(updatedWorkoutsForPlan);
    final userId = ref.watch(userIdProvider);
    final planRepository = ref.read(planRepositoryProvider);

    planRepository.addPlanToFirestore(
      widget.plan,
      userId!,
      workoutsToSave,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(Duration.zero);
    ref
        .read(updatedWorkoutsForPlan.notifier)
        .update((state) => widget.plan.workouts);
  }

  @override
  Widget build(BuildContext context) {
    final workouts = ref.watch(updatedWorkoutsForPlan);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          ref.read(updatedWorkoutsForPlan.notifier).update((state) => []);
          return true; // Return true to allow the back operation
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Fill in what your sessions look like',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                ...workouts.map((element) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      ExerciseInput(
                        workout: element,
                      ),
                    ],
                  );
                }).toList(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          ref
                              .read(updatedWorkoutsForPlan.notifier)
                              .update((state) => []);
                          GoRouter.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          savePlanToFirestore();
                          ref
                              .read(updatedWorkoutsForPlan.notifier)
                              .update((state) => []);

                          Future.delayed(Duration.zero, () {
                            GoRouter.of(context).go('/plans');
                          });
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseInput extends ConsumerStatefulWidget {
  const ExerciseInput({super.key, required this.workout});

  final Workout workout;

  @override
  ConsumerState<ExerciseInput> createState() => _ExerciseInputState();
}

class _ExerciseInputState extends ConsumerState<ExerciseInput> {
  String name = '';
  late int reps;
  late int weight;
  late int sets;
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reps = widget.workout.reps;
    weight = widget.workout.weight;
    sets = widget.workout.sets;
    _repsController.text = reps > 0 ? reps.toString() : '';
    _weightController.text = weight > 0 ? weight.toString() : '';
    _setsController.text = sets > 0 ? sets.toString() : '';

    setState(() {});
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _setsController.dispose();

    super.dispose();
  }

  void updateWorkoutProperty(int workoutId, String propertyName, int value) {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      widget.workout.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.fitness_center,
                      color: Colors.white,
                      size: 30,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Reps',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 48,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.purple.withOpacity(0.9), width: 2),
                        borderRadius: BorderRadius.circular(
                            8.0), // Optional: Add rounded corners
                      ),
                      child: NumericInputField(
                        controller: _repsController,
                        callback: (value) {
                          setState(() {
                            reps = int.tryParse(value) ?? 0;
                            updateWorkoutProperty(
                              widget.workout.id,
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
                  const Text('Sets',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 48,
                    height: 50,
                    child: NumericInputField(
                      controller: _setsController,
                      callback: (value) {
                        setState(() {
                          sets = int.tryParse(value) ?? 0;
                          updateWorkoutProperty(
                            widget.workout.id,
                            'sets',
                            sets,
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('Weight',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 48,
                    height: 50,
                    child: NumericInputField(
                      controller: _weightController,
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
                  const SizedBox(
                    width: 10,
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
    );
  }
}
