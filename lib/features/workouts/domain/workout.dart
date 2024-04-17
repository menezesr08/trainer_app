import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  const Workout(
      {required this.id,
      required this.name,
      this.minReps = 0,
      this.maxReps = 0});
  final String name;
  final int id;
  final int minReps;
  final int maxReps;

  @override
  List<Object> get props => [id, name, minReps, maxReps];

  @override
  bool get stringify => true;

  factory Workout.fromMap(Map<String, dynamic> data) {
    final id = data['id'] as int;
    final name = data['name'] as String;
    final minReps = data['minReps'] as int;
    final maxReps = data['maxReps'] as int;
    return Workout(
      id: id,
      name: name,
      minReps: minReps,
      maxReps: maxReps,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'minReps': minReps,
      'maxRep': maxReps,
    };
  }
}
