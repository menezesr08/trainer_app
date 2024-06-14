import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/plans/data/plan_repository.dart';
import 'package:trainer_app/features/plans/presentation/plan_card.dart';
import 'package:trainer_app/providers.dart';

void showAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AlertDialog(
      content: Text("hi"),
    ),
  );
}

class Plans extends ConsumerStatefulWidget {
  const Plans({super.key});

  @override
  ConsumerState<Plans> createState() => _ConsumerPlansState();
}

class _ConsumerPlansState extends ConsumerState<Plans> {
  void deletePlan(
    PlanRepository plansRepo,
    int planId,
    String userId,
  ) {
    plansRepo.deletePlan(planId, userId);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final userId = ref.watch(userIdProvider);
    final plansProvider = ref.watch(planRepositoryProvider);
    final notificationProvider = ref.read(notificationServiceProvider);
    notificationProvider.initialize(context);
    // notificationProvider.scheduleNotificationsEvery5Minutes();

    final plans = ref.watch(getPlansStream(userId!));

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
      body: plans.when(
        data: (plans) {
          return SingleChildScrollView(
            child: Column(
              children: [
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
                ElevatedButton(
                    onPressed: () {
                       GoRouter.of(context).push('/chat/check_in');
                    },
                    child: const Text('Click to chat')),
              ],
            ),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}
