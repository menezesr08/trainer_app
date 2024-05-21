import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';
import 'package:trainer_app/features/plans/presentation/plan_detail_card.dart';
import 'package:trainer_app/routing/app_router.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.onDelete, required this.plan});
  final VoidCallback onDelete;
  final Plan plan;

  @override
  Widget build(BuildContext context) {
    return Center(
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
        child: ExpansionTile(
          title: GestureDetector(
            onTap: () {
              GoRouter.of(context)
                  .pushNamed(AppRoute.completeWorkout.name, extra: plan);
            },
            onLongPress: () {
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
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            ),
          ),
          children: [
            ...plan.workouts.map(
              (e) => PlanDetailCard(w: e),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}