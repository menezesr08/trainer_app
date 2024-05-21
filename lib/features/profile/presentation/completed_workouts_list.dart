import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/profile/presentation/completed_workout_card.dart';
import 'package:trainer_app/features/workouts/data/workouts_repository.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';

class CompletedWorkoutsList extends ConsumerWidget {
  const CompletedWorkoutsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userId = authRepository.currentUser!.uid;
    final workoutsRepository = ref.read(workoutsRepositoryProvider);

    final completedWorkoutsStream =
        workoutsRepository.getCompletedWorkoutsFromFirestore(userId);
    return StreamBuilder<List<CompletedWorkout>>(
        stream: completedWorkoutsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<CompletedWorkout> completedWorkouts = snapshot.data!;
            final sortedCompletedWorkouts = completedWorkouts
              ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
            return Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pop();
                  },
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ),
                ),
                title: const Text(
                  'Completed Workouts',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
              ),
              body: SingleChildScrollView(
                child: Column(children: [
                  ...sortedCompletedWorkouts
                      .map((w) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.purple.withOpacity(0.9),
                                    Colors.black.withOpacity(0.9),
                                  ],
                                  stops: const [0.0, 0.7],
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: CompletedWorkoutCard(
                                w: w,
                              ),
                            ),
                          ))
                      .toList()
                ]),
              ),
            );
          }
        });
  }
}
