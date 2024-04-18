import 'package:equatable/equatable.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

class UserWorkout extends Equatable {
  const UserWorkout({required this.workout, this.completedReps = 0});
  final Workout workout;
  final int completedReps;

  @override
  List<Object> get props => [workout, completedReps];

  @override
  bool get stringify => true;

  factory UserWorkout.fromMap(Map<String, dynamic> data) {
    final workout = data['workout'] as Workout;
    final completedReps = data['completedReps'] as int;
    return UserWorkout(
      workout: workout,
      completedReps: completedReps,
    );
  }

  Map<String, dynamic> toMap() {
    return {'workouts': workout, 'completedReps': completedReps};
  }
}
