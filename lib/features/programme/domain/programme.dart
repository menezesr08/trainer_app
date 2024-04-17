import 'package:equatable/equatable.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

class Programme extends Equatable {
  const Programme({required this.name, required this.workouts});
  final String name;
  final List<Workout> workouts;

  @override
  List<Object> get props => [name, workouts];

  @override
  bool get stringify => true;

  factory Programme.fromMap(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final workouts = data['workouts'] as List<Workout>;
    return Programme(name: name, workouts: workouts);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'workouts': workouts};
  }
}
