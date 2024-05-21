import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/common_widgets/option_row.dart';

class Insights extends StatelessWidget {
  const Insights({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'Insights',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          OptionRow(
            title: 'Individual workout',
            onTapped: () {
              GoRouter.of(context).push('/insights/individualWorkoutOptions');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          OptionRow(
            title: 'Total',
            onTapped: () {
              GoRouter.of(context).push('/profile/completedWorkouts');
            },
          )
        ],
      ),
    );
  }
}
