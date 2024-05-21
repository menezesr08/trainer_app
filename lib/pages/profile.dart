import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/workouts/data/workouts_repository.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Your Plans',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.search),
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        CompletedWorkoutsList()
      ],
    );
  }
}

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
            return SingleChildScrollView(
              child: Column(children: [
                ...completedWorkouts
                    .map((w) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.purple.withOpacity(0.9),
                                  Colors.black.withOpacity(
                                      0.9), // Adjust opacity as needed
                                  // Adjust opacity as needed
                                ],
                                stops: const [0.0, 0.7],
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    w.name,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ...w.workoutSets.map(
                                  (e) => Row(
                                      textBaseline: TextBaseline.ideographic,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                          child: Text(
                                            '${e.number + 1}:    ${e.reps} reps  ${e.weight} weight',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList()
              ]),
            );
          }
        });
  }
}
