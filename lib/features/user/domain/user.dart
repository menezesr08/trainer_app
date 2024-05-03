import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.email, required this.type, required this.id});
  final String email;
  final String type;
  final String id;
  @override
  List<Object?> get props => [email, type];

  @override
  bool get stringify => true;

  factory User.fromJson(Map<String, dynamic> data) {
    final email = data['email'];
    final type = data['type'];
    final id = data['id'];
    return User(email: email, type: type, id: id);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'type': type,
      'id': id,
    };
  }
}
