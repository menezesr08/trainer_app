import 'package:trainer_app/classes/workout.dart';

class Programme {
  String programmeName;
  List<Workout> workouts;
  String day;

  Programme({
    required this.programmeName,
    required this.workouts,
    required this.day
  });
}
