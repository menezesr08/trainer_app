import 'package:equatable/equatable.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

class Plan extends Equatable {
  const Plan({required this.id, required this.name, required this.workouts});
  final String name;
  final List<Workout> workouts;
  final int id;
  @override
  List<Object> get props => [id, name, workouts];

  @override
  bool get stringify => true;

  factory Plan.fromMap(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final List<Map<String, dynamic>> workoutDataList =
        (data['workouts'] as List<dynamic>).cast<Map<String, dynamic>>();

    // Convert the list of workout data maps into Workout objects
    final List<Workout> workouts = workoutDataList
        .map((workoutData) => Workout.fromMap(workoutData))
        .toList();

    final id = data['id'] as int;

    return Plan(
      id: id,
      name: name,
      workouts: workouts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'workouts': workouts.map((workout) => workout.toMap()).toList()
    };
  }
}
