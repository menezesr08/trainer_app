import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';

import 'package:trainer_app/features/plans/presentation/plans_providers.dart';
import 'package:trainer_app/features/workouts/data/workouts_repository.dart';
import 'package:trainer_app/features/workouts/domain/base_workout.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

class CreatePlan extends ConsumerStatefulWidget {
  const CreatePlan({super.key});

  @override
  ConsumerState<CreatePlan> createState() => _CreatePlanState();
}

class _CreatePlanState extends ConsumerState<CreatePlan> {
  List<BaseWorkout> _options = [];
  DateTime? selectedDate;
  bool isRecurring = false;
  String recurrencePattern = 'Weekly';
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
        resizeToAvoidBottomInset: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const CreatePlanTitle(),
            const SizedBox(
              height: 30,
            ),
            ExerciseSelection(options: _options),
            const SizedBox(
              height: 70,
            ),
            const ScheduledAtSelector(),
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
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white.withOpacity(0.4),
                      size: 40,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      final planState = ref.read(createPlanProvider.notifier);
                      final selectedOptions = planState.getWorkouts();
                      final workouts = convertBaseWorkouts(selectedOptions);

                      final newPlan = Plan(
                          name: planState.getName(),
                          workouts: workouts,
                          scheduledAt: planState.getScheduledAt(),
                          isRecurring: planState.getRecurring(),
                          recurringType: planState.getRecurringType());

                      GoRouter.of(context)
                          .push('/plans/detail', extra: newPlan);
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white.withOpacity(0.4),
                      size: 40,
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
}

class ScheduledAtSelector extends ConsumerStatefulWidget {
  const ScheduledAtSelector({super.key});

  @override
  ConsumerState<ScheduledAtSelector> createState() =>
      _ScheduledAtSelectorState();
}

class _ScheduledAtSelectorState extends ConsumerState<ScheduledAtSelector> {
  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final selectedDate = ref.watch(createPlanProvider).scheduledAt;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      ref.read(createPlanProvider.notifier).setScheduledAt(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRecurring = ref.watch(createPlanProvider).isRecurring;
    final recurringType = ref.watch(createPlanProvider).recurringType;
    final selectedDate = ref.watch(createPlanProvider).scheduledAt;
    final formattedDate = selectedDate != null
        ? DateFormat('MMMM dd, yyyy').format(selectedDate)
        : 'No date selected';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Schedule a day to complete this plan: '),
          const SizedBox(
            height: 10,
          ),
          SwitchListTile(
            title: const Text('Recurring'),
            value: isRecurring,
            onChanged: (bool value) {
              ref.read(createPlanProvider.notifier).setRecurring(value);
            },
          ),
          if (isRecurring) ...[
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: Colors.white.withOpacity(0.1),
              title: Text(formattedDate),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: () => _selectDate(context, ref),
            ),
            DropdownButton<String>(
              value: recurringType,
              onChanged: (newValue) {
                ref
                    .read(createPlanProvider.notifier)
                    .setRecurringType(newValue!);
              },
              items: <String>['Weekly', 'Monthly']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ] else ...[
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: Colors.white.withOpacity(0.1),
              title: Text(formattedDate),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: () => _selectDate(context, ref),
            ),
          ],
        ],
      ),
    );
  }
}

class CreatePlanTitle extends ConsumerStatefulWidget {
  const CreatePlanTitle({super.key});

  @override
  ConsumerState<CreatePlanTitle> createState() => _CreatePlanTitleState();
}

class _CreatePlanTitleState extends ConsumerState<CreatePlanTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s the name of your plan?',
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            onChanged: (value) {
              ref.read(createPlanProvider.notifier).setName(value);
            },
          ),
        ],
      ),
    );
  }
}

class ExerciseSelection extends ConsumerStatefulWidget {
  const ExerciseSelection({super.key, required this.options});
  final List<BaseWorkout> options;

  @override
  ConsumerState<ExerciseSelection> createState() => _ExerciseSelectionState();
}

class _ExerciseSelectionState extends ConsumerState<ExerciseSelection> {
  BaseWorkout? _selectedOption;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select 5 exercises',
          ),
          const SizedBox(
            height: 5,
          ),
          DropdownButtonFormField(
            value: _selectedOption,
            hint: const Text(
              'Select an option',
            ),
            items: widget.options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
              ref.read(createPlanProvider.notifier).addWorkout(value!);
            },
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: ref
                .watch(createPlanProvider)
                .workouts
                .map((option) => Chip(
                      label: Text(option.name),
                      deleteIcon: const Icon(Icons.clear),
                      onDeleted: () {
                        ref
                            .read(createPlanProvider.notifier)
                            .removeWorkout(option);
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
