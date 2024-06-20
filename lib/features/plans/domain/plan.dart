import 'package:equatable/equatable.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

class Plan extends Equatable {
  const Plan({
    required this.name,
    required this.workouts,
    required this.scheduledAt,
    this.id,
    this.isRecurring = false,
    this.recurringType = "Weekly"
  });
  final String name;
  final List<Workout> workouts;
  final int? id;
  final DateTime? scheduledAt;
  final bool? isRecurring;
  final String? recurringType;
  @override
  List<Object> get props => [id!, name, workouts];

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

    final scheduledAtString = data['scheduledAt'] as String?;
    final DateTime? scheduledAt =
        scheduledAtString != null ? DateTime.parse(scheduledAtString) : null;

    final id = data['id'] as int?;

    final isRecurring = data['isRecurring'] as bool?;

    final recurringType = data['recurringType'] as String?;

    return Plan(
      id: id,
      name: name,
      workouts: workouts,
      scheduledAt: scheduledAt,
      isRecurring: isRecurring,
      recurringType: recurringType
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'workouts': workouts.map((workout) => workout.toMap()).toList(),
      'scheduledAt': scheduledAt?.toIso8601String(),
      'isRecurring': isRecurring,
      'recurringType': recurringType
    };
  }

  Plan copyWith({
    String? name,
    List<Workout>? workouts,
    int? id,
    DateTime? scheduledAt,
    bool? isRecurring,
    String? recurringType,
  }) {
    return Plan(
      name: name ?? this.name,
      workouts: workouts ?? this.workouts,
      id: id ?? this.id,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringType: recurringType ?? this.recurringType,
    );
  }
}
