import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/plans/data/plan_repository.dart';
import 'package:trainer_app/features/plans/presentation/plan_card.dart';

void showAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AlertDialog(
      content: Text("hi"),
    ),
  );
}

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
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userId = authRepository.currentUser!.uid;
    final plansProvider = ref.watch(planRepositoryProvider);
    final plans = ref.watch(getPlansStream(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location and Plans'),
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
      body: plans.when(
        data: (plans) {
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
                      onDelete: () => plansProvider.deletePlan(e.id, userId)))
                  .toList(),
            ]),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}
