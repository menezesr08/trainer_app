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
        body: Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(color: textColor),
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: textColor), // Change line color here
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white), // Change line color when focused
                  ),
                  hintText: 'Type here...',
                  hintStyle: TextStyle(
                    color: textColor,
                  ),
                  labelStyle: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  labelText: 'What\'s the name of your plan?',
                ),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select 5 exercises: ',
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    DropdownButtonFormField(
                      value: _selectedOption,
                      hint: const Text(
                        'Select an option',
                        style: TextStyle(color: textColor),
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
                    const Text(
                      'Selected Options:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFFD3D3D3), // Change color of the Previous button
                      ),
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: textColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Previous',
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFFD3D3D3), // Change color of the Previous button
                      ),
                      onPressed: () {
                        ref
                            .read(selectedWorkoutsForPlan.notifier)
                            .update((state) => _selectedOptions);
                        GoRouter.of(context).push('/plans/detail/$_name');
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(color: textColor),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            color: textColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
