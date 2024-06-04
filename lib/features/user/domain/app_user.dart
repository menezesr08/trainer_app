import 'package:equatable/equatable.dart';
import 'package:trainer_app/features/profile/constants.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.email,
    required this.type,
    required this.id,
    required this.name,
    this.gender,
    this.bodyWeight,
    this.age,
    this.location,
  });

  final String email;
  final String type;
  final String id;
  final Gender? gender;
  final int? bodyWeight;
  final int? age;
  final String? location;
  final String name;

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
        ? Gender.values
            .firstWhere((e) => e.toString().split('.').last == genderString)
        : null;
    final bodyWeight = data['bodyWeight'];
    final age = data['age'];
    final location = data['location'];
    final name = data['name'];
    return AppUser(
        email: email,
        type: type,
        id: id,
        gender: gender,
        bodyWeight: bodyWeight,
        age: age,
        location: location,
        name: name);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'type': type,
      'id': id,
      'gender': gender?.toString().split('.').last,
      'bodyWeight': bodyWeight,
      'age': age,
      'location': location,
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
      String? name}) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      bodyWeight: bodyWeight ?? this.bodyWeight,
      location: location ?? this.location,
      type: type ?? this.type,
      name: name ?? this.name,
    );
  }
}
