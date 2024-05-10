import 'package:equatable/equatable.dart';

class WorkoutSet extends Equatable {
  final int number;
  final int weight;
  final int reps;

  const WorkoutSet({
    required this.number,
    required this.weight,
    required this.reps,
  });

  @override
  List<Object> get props => [number, reps, weight];

  @override
  bool get stringify => true;

  factory WorkoutSet.fromMap(Map<String, dynamic> data) {
    final number = data['number'] as int;
    final reps = data['reps'] as int;
    final weight = data['weight'] as int;

    return WorkoutSet(
      number: number,
      reps: reps,
      weight: weight,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'reps': reps,
      'weight': weight,
    };
  }

  WorkoutSet copyWith({
    int? number,
    int? reps,
    int? weight,
  }) {
    return WorkoutSet(
      number: number ?? this.number,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
    );
  }
}
