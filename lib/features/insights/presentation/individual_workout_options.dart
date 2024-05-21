import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/common_widgets/option_row.dart';
import 'package:trainer_app/features/workouts/data/workouts_repository.dart';

class IndividualWorkoutOptions extends ConsumerWidget {
  const IndividualWorkoutOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsyncValue = ref.watch(baseWorkoutsProvider);
    return SingleChildScrollView(
        child: workoutsAsyncValue.when(
      data: (baseWorkouts) {
        return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(
            height: 50,
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Choose a workout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          ...baseWorkouts.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: OptionRow(
                  title: e.name,
                  onTapped: () {
                    GoRouter.of(context).push(
                      '/insights/individualWorkoutInsights',
                      extra: e,
                    );
                  },
                ),
              ))
        ]);
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    ));
  }
}
