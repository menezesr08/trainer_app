import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/common_widgets/option_row.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
                  'Profile',
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
            title: 'Update Profile',
            onTapped: () {
              GoRouter.of(context).push('/profile/updateProfile');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          OptionRow(
            title: 'Completed Workouts',
            onTapped: () {
              GoRouter.of(context).push('/profile/completedWorkouts');
            },
          )
        ],
      ),
    );
  }
}
