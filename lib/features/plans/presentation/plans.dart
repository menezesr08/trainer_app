import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/plans/data/plan_repository.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';
import 'package:trainer_app/routing/app_router.dart';

class Plans extends ConsumerWidget {
  const Plans({super.key});

  void deletePlan(
    PlanRepository plansRepo,
    int planId,
    String userId,
  ) {
    plansRepo.deletePlan(planId, userId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final plansProvider = ref.watch(planRepositoryProvider);
    final userId = authRepository.currentUser!.uid;
    final plans = plansProvider.getPlansFromFirestore(userId);

    return Scaffold(
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
        body: StreamBuilder<List<Plan>>(
          stream: plans,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Plan> plans = snapshot.data!;
              return SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Row(
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
                  const SizedBox(
                    height: 30,
                  ),
                  ...plans
                      .map((e) => PlanCard(
                          plan: e,
                          onDelete: () =>
                              plansProvider.deletePlan(e.id, userId)))
                      .toList(),
                ]),
              );
            }
          },
        ));
  }
}

class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.onDelete, required this.plan});
  final VoidCallback onDelete;
  final Plan plan;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context)
              .pushNamed(AppRoute.completeWorkout.name, extra: plan);
        },
        onLongPress: () {
          // Show a bottom sheet with edit and delete options
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                      GoRouter.of(context).push(
                        '/plans/detail/${plan.name}',
                        extra: plan,
                      );
                    },
                    child: const Text('Edit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onDelete();
                      Navigator.pop(context); // Close the bottom sheet
                      // Implement delete functionality
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.purple.withOpacity(0.9),
                      Colors.black.withOpacity(0.9), // Adjust opacity as needed
                      // Adjust opacity as needed
                    ],
                    stops: const [0.0, 0.7],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                        leading: const Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                          size: 50,
                        ),
                        title: Text(
                          '${plan.workouts.length} exercises',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                        subtitle: Text(
                          plan.name,
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
