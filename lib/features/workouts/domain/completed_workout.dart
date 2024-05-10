import 'package:equatable/equatable.dart';
import 'package:trainer_app/features/workouts/domain/set.dart';

class CompletedWorkout extends Equatable {
  final List<WorkoutSet> workoutSets;
  final int workoutId;
  final int id;

  const CompletedWorkout(
      {required this.workoutSets, required this.workoutId, required this.id});

  @override
  List<Object> get props => [id, workoutSets, workoutId];

  int get totalReps {
    return workoutSets.fold(0, (total, set) => total + set.reps);
  }

  int get totalWeight {
    return workoutSets.fold(0, (total, set) => total + set.weight);
  }

  @override
  bool get stringify => true;

  factory CompletedWorkout.fromMap(Map<String, dynamic> data) {
    final List<Map<String, dynamic>> setsDataList =
        (data['sets'] as List<dynamic>).cast<Map<String, dynamic>>();

    final List<WorkoutSet> sets =
        setsDataList.map((set) => WorkoutSet.fromMap(set)).toList();

    final int workoutId = data['workoutId'] as int;

    final int id = data['id'] as int;

    return CompletedWorkout(id: id, workoutSets: sets, workoutId: workoutId);
  }

  Map<String, dynamic> toMap() {
    return {
      'sets': workoutSets.map((set) => set.toMap()).toList(),
      'workoutId': workoutId,
      'id': id,
    };
  }

  CompletedWorkout copyWith({
    int? workoutId,
    List<WorkoutSet>? workoutSets,
    int? id,
  }) {
    return CompletedWorkout(
        workoutId: workoutId ?? this.workoutId,
        workoutSets: workoutSets ?? this.workoutSets,
        id: id ?? this.id);
  }
}
