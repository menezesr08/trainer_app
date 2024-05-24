import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/constants/colors.dart';
import 'package:trainer_app/features/plans/presentation/plans_providers.dart';
import 'package:trainer_app/features/workouts/data/workouts_repository.dart';
import 'package:trainer_app/features/workouts/domain/base_workout.dart';

class CreatePlan extends ConsumerStatefulWidget {
  const CreatePlan({super.key});

  @override
  ConsumerState<CreatePlan> createState() => _CreatePlanState();
}

class _CreatePlanState extends ConsumerState<CreatePlan> {
  String _name = '';
  BaseWorkout? _selectedOption;
  final List<BaseWorkout> _selectedOptions = [];
  List<BaseWorkout> _options = [];

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    final workouts = ref.read(workoutsRepositoryProvider);
    _options = await workouts.getBaseWorkouts();

    setState(() {
      // Update state variables here
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select 5 exercises',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: DropdownButtonFormField(
                      value: _selectedOption,
                      hint: const Text(
                        'Select an option',
                      ),
                      items: _options.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                          _selectedOptions.add(value!);
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Selected Options:',
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: _selectedOptions
                        .map((option) => Chip(
                              label: Text(option.name),
                              deleteIcon: const Icon(Icons.clear),
                              onDeleted: () {
                                setState(() {
                                  _selectedOptions.remove(option);
                                });
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
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
                      ref
                          .read(selectedWorkoutsForPlan.notifier)
                          .update((state) => _selectedOptions);
                      GoRouter.of(context).push('/plans/detail/$_name');
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
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
    );
  }
}
