import 'package:trainer_app/constants/enums.dart';
import 'package:trainer_app/features/user/domain/user_preferences.dart';

class OnboardingData {
  final int? age;
  final int? bodyWeight;
  final Gender? gender;
  final UserPreferences? preferences;

  OnboardingData({
    required this.age,
    required this.bodyWeight,
    required this.gender,
    required this.preferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'bodyWeight': bodyWeight,
      'user_preferences': preferences?.toJson(),
    };
  }
}
