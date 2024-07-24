class UserPreferences {
  final int gymSessionsPerWeek;
  final int dailyCalories;
  final int hoursOfSleep;

  UserPreferences({
    required this.gymSessionsPerWeek,
    required this.dailyCalories,
    required this.hoursOfSleep,
  });

  Map<String, dynamic> toJson() {
    return {
      'gymSessionsPerWeek': gymSessionsPerWeek,
      'dailyCalories': dailyCalories,
      'hoursOfSleep': hoursOfSleep,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      gymSessionsPerWeek: json['gymSessionsPerWeek'] as int,
      dailyCalories: json['dailyCalories'] as int,
      hoursOfSleep: json['hoursOfSleep'] as int,
    );
  }
}
