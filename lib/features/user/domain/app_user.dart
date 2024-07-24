import 'package:equatable/equatable.dart';
import 'package:trainer_app/constants/enums.dart';
import 'package:trainer_app/features/user/domain/user_preferences.dart';

class AppUser extends Equatable {
  const AppUser(
      {required this.email,
      required this.type,
      required this.id,
      required this.name,
      this.gender,
      this.bodyWeight,
      this.age,
      this.location,
      this.userPreferences});

  final String email;
  final String type;
  final String id;
  final Gender? gender;
  final int? bodyWeight;
  final int? age;
  final String? location;
  final String name;
  final UserPreferences? userPreferences;

  @override
  List<Object?> get props =>
      [email, type, gender, bodyWeight, age, location, name];

  @override
  bool get stringify => true;

  factory AppUser.fromJson(Map<String, dynamic> data) {
    final email = data['email'];
    final type = data['type'];
    final id = data['id'];
    final genderString = data['gender'];
    final gender = genderString != null
        ? stringToGenderMap[genderString]
        : null;
    final bodyWeight = data['bodyWeight'];
    final age = data['age'];
    final location = data['location'];
    final name = data['name'];
    final userPreferences = data['user_preferences'] != null
        ? UserPreferences.fromJson(data['user_preferences'])
        : null;

    return AppUser(
        email: email,
        type: type,
        id: id,
        gender: gender,
        bodyWeight: bodyWeight,
        age: age,
        location: location,
        name: name,
        userPreferences: userPreferences);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'type': type,
      'id': id,
      'gender': genderToStringMap[gender],
      'bodyWeight': bodyWeight,
      'age': age,
      'location': location,
      'user_preferences': userPreferences?.toJson()
    };
  }

  AppUser copyWith(
      {String? email,
      Gender? gender,
      int? age,
      int? bodyWeight,
      String? location,
      String? type,
      String? id,
      String? name,
      UserPreferences? userPreferences}) {
    return AppUser(
        id: id ?? this.id,
        email: email ?? this.email,
        gender: gender ?? this.gender,
        age: age ?? this.age,
        bodyWeight: bodyWeight ?? this.bodyWeight,
        location: location ?? this.location,
        type: type ?? this.type,
        name: name ?? this.name,
        userPreferences: userPreferences ?? this.userPreferences);
  }
}
