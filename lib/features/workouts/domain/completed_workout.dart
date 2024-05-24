import 'package:equatable/equatable.dart';
import 'package:trainer_app/features/workouts/domain/set.dart';

class CompletedWorkout extends Equatable {
  final List<WorkoutSet> workoutSets;
  final int workoutId;
  final int id;
  final String name;
  final DateTime completedAt;
  final String planName;

  const CompletedWorkout({
    required this.workoutSets,
    required this.workoutId,
    required this.id,
    required this.name,
    required this.completedAt,
    required this.planName,
  });

  @override
  List<Object> get props =>
      [id, workoutSets, workoutId, name, completedAt, planName];

  int get totalReps {
    return workoutSets.fold(0, (total, set) => total + set.reps);
  }

  int get totalWeight {
    return workoutSets.fold(0, (total, set) => total + set.weight);
  }

  int get maxWeight {
  return workoutSets.fold(0, (max, set) => set.weight > max ? set.weight : max);
}

  int get totalVolume {
    // Sum the volume of all sets
    return workoutSets.fold(0, (sum, set) => sum + (set.reps * set.weight));
  }

  double get averageReps {
    if (workoutSets.isEmpty) return 0;
    return totalReps / workoutSets.length;
  }

  double get averageWeight {
    if (workoutSets.isEmpty) return 0;
    return totalWeight / workoutSets.length;
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

    final String name = data['name'] as String;
    final String completedAtString = data['completed_at'] as String;
    final DateTime completedAt = DateTime.parse(completedAtString);

    final String planName = data['plan_name'] as String;

    return CompletedWorkout(
        id: id,
        workoutSets: sets,
        workoutId: workoutId,
        name: name,
        completedAt: completedAt,
        planName: planName);
  }

  Map<String, dynamic> toMap() {
    return {
      'sets': workoutSets.map((set) => set.toMap()).toList(),
      'workoutId': workoutId,
      'id': id,
      'name': name,
      'completed_at': completedAt.toIso8601String(),
      'plan_name': planName
    };
  }

  CompletedWorkout copyWith(
      {int? workoutId,
      List<WorkoutSet>? workoutSets,
      int? id,
      String? name,
      DateTime? completedAt,
      String? planName}) {
    return CompletedWorkout(
        workoutId: workoutId ?? this.workoutId,
        workoutSets: workoutSets ?? this.workoutSets,
        name: name ?? this.name,
        completedAt: completedAt ?? this.completedAt,
        id: id ?? this.id,
        planName: planName ?? this.planName);
  }
}
