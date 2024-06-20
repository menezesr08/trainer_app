import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/workouts/domain/base_workout.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

class CreatePlan {
  final String name;
  final List<BaseWorkout> workouts;
  final DateTime? scheduledAt;
  final bool isRecurring;
  final String recurringType;

  const CreatePlan(
      {required this.name,
      required this.workouts,
      required this.scheduledAt,
      this.isRecurring = false,
      this.recurringType = "Weekly"});

  CreatePlan copyWith({
    String? name,
    List<BaseWorkout>? workouts,
    int? id,
    DateTime? scheduledAt,
    bool? isRecurring,
    String? recurringType,
  }) {
    return CreatePlan(
      name: name ?? this.name,
      workouts: workouts ?? this.workouts,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringType: recurringType ?? this.recurringType,
    );
  }
}

class CreateNewPlanNotifier extends StateNotifier<CreatePlan> {
  CreateNewPlanNotifier()
      : super(const CreatePlan(
            name: '', workouts: [], scheduledAt: null, isRecurring: false));

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  String getName() {
    return state.name;
  }

  void addWorkout(BaseWorkout workout) {
    state = state.copyWith(workouts: [...state.workouts, workout]);
  }

  void removeWorkout(BaseWorkout workout) {
    state = state.copyWith(
      workouts: state.workouts.where((item) => item.id != workout.id).toList(),
    );
  }

  void setScheduledAt(DateTime scheduledAt) {
    state = state.copyWith(scheduledAt: scheduledAt);
  }

   DateTime? getScheduledAt() {
    return state.scheduledAt;
  }

  void setRecurring(bool isRecurring) {
    state = state.copyWith(isRecurring: isRecurring);
  }

  bool getRecurring() {
    return state.isRecurring;
  }

  void setRecurringType(String recurringType) {
    state = state.copyWith(recurringType: recurringType);
  }

   String getRecurringType() {
    return state.recurringType;
  }


  List<BaseWorkout> getWorkouts() {
    return state.workouts;
  }
}

final createPlanProvider =
    StateNotifierProvider<CreateNewPlanNotifier, CreatePlan>((ref) {
  return CreateNewPlanNotifier();
});

final updatedWorkoutsForPlan = StateProvider<List<Workout>>((ref) {
  return [];
});
