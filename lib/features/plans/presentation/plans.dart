import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';

class Plans extends ConsumerWidget {
  const Plans({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF353d4a),
        title: const Text('Plans'),
        actions: [
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go('/plans/createPlan');
        },
        child: Icon(Icons.add),
        backgroundColor:
            Color(0xFF797c82), // Change to your desired background color
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // Adjust the value as needed
        ),
      ),
      body: Container(
        color: Colors.black,
      ),
    );
  }
}
