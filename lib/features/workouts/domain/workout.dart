import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  const Workout(
      {required this.id,
      required this.name,
      required this.reps,
      required this.sets,
      this.weight = 0});
  final String name;
  final int id;
  final int reps;
  final int weight;
  final int sets;

  @override
  List<Object> get props => [id, name, reps, weight, sets];

  @override
  bool get stringify => true;

  factory Workout.fromMap(Map<String, dynamic> data) {
    final id = data['id'] as int;
    final name = data['name'] as String;
    final reps = data['reps'] as int;
    final weight = data['weight'] as int;
    final sets = data['sets'] as int;

    return  Workout(id: id, name: name, reps: reps, weight: weight, sets: sets);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'reps': reps,
      'weight': weight,
      'sets': sets
    };
  }

  Workout copyWith({
    int? id,
    String? name,
    int? reps,
    int? sets,
    int? weight,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      reps: reps ?? this.reps,
      sets: sets ?? this.sets,
      weight: weight ?? this.weight,
    );
  }
}
