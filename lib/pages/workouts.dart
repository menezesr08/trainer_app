import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/trainer/programme/data/workouts_repository.dart';

// need to build out firebase auth to save how many reps user did in user object
class Workouts extends ConsumerWidget {
  Workouts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final workoutsRepository = ref.watch(workoutsRespositoryProvider);
    final allWorkoutsQuery = ref.watch(allWorkoutsQueryProvider);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show popup when FAB is pressed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add a workout'),
                  content: Text('This is your popup content.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Perform action when button in popup is pressed
                        // For example, close the popup
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('Programmes'),
          actions: [
            // TextButton(
            //   style: TextButton.styleFrom(
            //     backgroundColor: Colors.black,
            //     fixedSize: const Size(50, 50),
            //   ),
            //   child: const Text('Add Program'),
            //   onPressed: () => workoutsRepository.addProgramme(
            //       uid: authRepository.currentUser!.uid, name: 'Workout 3'),
            // ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                fixedSize: const Size(50, 50),
              ),
              child: const Text('Log out'),
              onPressed: () => authRepository.signOut(),
            ),
          ],
        ),
        body: Text('test'));
  }
}
