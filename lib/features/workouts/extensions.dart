import 'package:trainer_app/features/workouts/domain/set.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

extension CopyWithPropertyExtension on Workout {
  Workout copyWithProperty(String propertyName, dynamic value) {
    switch (propertyName) {
      case 'reps':
        return copyWith(reps: value as int);
      case 'sets':
        return copyWith(sets: value as int);
      case 'weight':
        return copyWith(weight: value as int);
      // Add more cases for other properties as needed
      default:
        return this; // Return the original workout if property name is not recognized
    }
  }
}

extension CopyWithPropertyExtensionOnWorkoutSet on WorkoutSet {
  WorkoutSet copyWithProperty(String propertyName, dynamic value) {
    switch (propertyName) {
      case 'number':
        return copyWith(number: value as int);
      case 'reps':
        return copyWith(reps: value as int);
      case 'weight':
        return copyWith(weight: value as int);
      // Add more cases for other properties as needed
      default:
        return this; // Return the original workout if property name is not recognized
    }
  }
}

