import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/constants/colors.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/plans/data/plan_repository.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';
import 'package:trainer_app/routing/app_router.dart';

class Plans extends ConsumerWidget {
  const Plans({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final plansProvider = ref.watch(planRepositoryProvider);
    final plans =
        plansProvider.getPlansFromFirestore(authRepository.currentUser!.uid);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF353d4a),
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
          backgroundColor: const Color(0xFF797c82),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<List<Plan>>(
          future: plans,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Plan> plans = snapshot.data!;
              return SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: Column(
                    children: plans.map((plan) {
                      return GestureDetector(
                          onTap: () {
                            GoRouter.of(context).pushNamed(
                                AppRoute.completeWorkout.name,
                                extra: plan);
                          },
                          child: planCard(plan));
                    }).toList(),
                  ),
                ),
              );
            }
          },
        ));
  }

  Widget planCard(Plan plan) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: textColor,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      plan.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ...[
                      for (var w in plan.workouts) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              w.name,
                              style: const TextStyle(fontSize: 25),
                            ),
                            Text(
                              '${w.reps.toString()} reps',
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              '${w.sets.toString()} sets X ${w.weight.toString()}kg',
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        const SizedBox(
                            width: 8), // Add desired space between Text widgets
                      ],
                    ],
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
