import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/features/plans/data/plan_repository.dart';
import 'package:trainer_app/features/plans/presentation/plan_card.dart';
import 'package:trainer_app/providers/plan_providers.dart';
import 'package:trainer_app/providers/user_providers.dart';
import 'package:trainer_app/services/notification_service.dart';

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
  List<PendingNotificationRequest> _pendingNotifications = [];
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

  Future<void> showNotification() async {
    final notificationProvider = ref.read(notificationServiceProvider);
    final notifications =
        await notificationProvider.getScheduledNotifications();

    setState(() {
      _pendingNotifications = notifications;
    });
  }

  void _showScheduledNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Scheduled Notifications"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _pendingNotifications.length,
              itemBuilder: (context, index) {
                final notification = _pendingNotifications[index];
                return ListTile(
                  title: Text(notification.title ?? "No Title"),
                  subtitle: Text(notification.body ?? "No Body"),
                  trailing: Text(notification.id.toString()),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final userId = ref.watch(userIdProvider);
    final plansProvider = ref.watch(planRepositoryProvider);
    final notificationProvider = ref.read(notificationServiceProvider);
    notificationProvider.initialize(context);
    notificationProvider.checkAndScheduleNotification();

    final plans = ref.watch(getPlansStream(userId!));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go('/plans/createPlan');
        },
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
                    .map(
                      (e) => PlanCard(
                        plan: e,
                        onDelete: () => plansProvider.deletePlan(e.id!, userId),
                      ),
                    )
                    .toList(),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).push('/chat/standard');
                  },
                  child: const Text('Click to chat'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await showNotification();
                    _showScheduledNotificationsDialog();
                  },
                  child: const Text("Show Scheduled Notifications"),
                ),
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
