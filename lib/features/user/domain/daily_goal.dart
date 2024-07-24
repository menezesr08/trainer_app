class DailyGoal {
  final String date;
  final bool? caloriesMet;
  final bool? sleepHoursMet;
  final bool? workoutCompleted;
  final int? caloriesPointsEarned;
  final int? sleepPointsEarned;
  final int? workoutPointsEarned;

  DailyGoal({
    required this.date,
    required this.caloriesMet,
    required this.sleepHoursMet,
    required this.caloriesPointsEarned,
    required this.sleepPointsEarned,
    required this.workoutCompleted,
    required this.workoutPointsEarned,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'caloriesMet': caloriesMet,
      'sleepHoursMet': sleepHoursMet,
      'caloriesPointsEarned': caloriesPointsEarned,
      'sleepPointsEarned': sleepPointsEarned,
      'workoutCompleted': workoutCompleted,
      'workoutPointsEarned': workoutPointsEarned
    };
  }

  factory DailyGoal.fromJson(Map<String, dynamic> json) {
    return DailyGoal(
        date: json['date'],
        caloriesMet: json['caloriesMet'],
        sleepHoursMet: json['sleepHoursMet'],
        caloriesPointsEarned: json['caloriesPointsEarned'],
        sleepPointsEarned: json['sleepPointsEarned'],
        workoutCompleted: json['workoutCompleted'],
        workoutPointsEarned: json['workoutPointsEarned']);
  }
}
