import 'package:flutter/material.dart';
import 'package:trainer_app/classes/programme.dart';
import 'package:trainer_app/classes/workout.dart';
// need to build out firebase auth to save how many reps user did in user object
class InputWorkouts extends StatelessWidget {
  InputWorkouts({super.key});

  final List<Programme> programmes = [
    Programme(programmeName: 'Push pull', day: 'Mon', workouts: [
      Workout(name: 'Chest Press', numberOfSets: 3, minNumberOfReps: 8),
      Workout(name: 'Lat Pulldown', numberOfSets: 3, minNumberOfReps: 8),
      Workout(name: 'Chest flys', numberOfSets: 3, minNumberOfReps: 8),
      Workout(name: 'Bent over Row', numberOfSets: 3, minNumberOfReps: 8)
    ]),
    Programme(programmeName: 'Legs', day: 'Tues', workouts: [
      Workout(name: 'Leg press', numberOfSets: 3, minNumberOfReps: 8),
      Workout(name: 'Split Squats', numberOfSets: 3, minNumberOfReps: 8),
      Workout(name: 'Leg curl', numberOfSets: 3, minNumberOfReps: 8),
      Workout(name: 'Hamstring curl', numberOfSets: 3, minNumberOfReps: 8)
    ])
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount:
          programmes.length, // Change this to the number of cards you want
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4.0,
            child: ListTile(
              title: Text(programmes[index].programmeName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: programmes[index].workouts.map((workout) {
                  return Text(workout.name);
                }).toList(),
              ),
              leading: CircleAvatar(
                child: Text(programmes[index].day),
              ),
              onTap: () {
                // Action when the card is tapped
              },
            ),
          ),
        );
      },
    );
  }
}
