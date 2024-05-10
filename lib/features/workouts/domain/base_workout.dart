import 'package:equatable/equatable.dart';

class BaseWorkout extends Equatable {
  const BaseWorkout({
    required this.id,
    required this.name,
  });
  final String name;
  final int id;

  @override
  List<Object> get props => [id, name];

  @override
  bool get stringify => true;

  factory BaseWorkout.fromMap(Map<String, dynamic> data) {
    final id = data['id'] as int;
    final name = data['name'] as String;
    return BaseWorkout(id: id, name: name);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }
}
