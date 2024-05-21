import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/chat/chat.dart';

// need to build out firebase auth to save how many reps user did in user object
class Workouts extends ConsumerWidget {
  Workouts({super.key});

  Widget _buildCharacterMenu(
      String character, String description, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              character: character,
            ),
          ),
        );
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                  0.5), // Adjust color and opacity for the glow effect
              spreadRadius: 2,
              blurRadius:
                  5, // Adjust the blur radius to control the intensity of the glow
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 40,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return Scaffold(
        floatingActionButton: _buildCharacterMenu(
            'Gym Buddy', 'Ask me anything about fitness!', context),
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
                fixedSize: const Size(50, 50),
              ),
              child: const Text(
                'Log out',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => authRepository.signOut(),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PUSH - 11/05/2025',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text('Lateral'),
                  Text('Chest Press'),
                  Text('Bicep Curls'),
                  Text('Tricep dips'),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PULL - 13/05/2025',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text('Pulldown'),
                  Text('Chin ups'),
                  Text('Rows'),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ARMS - 16/05/2025',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text('Biceps'),
                  Text('Triceps'),
                  Text('Laterals'),
                ],
              ),
            ),
          ],
        ));
  }
}
