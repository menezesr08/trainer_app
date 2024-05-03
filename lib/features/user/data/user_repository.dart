import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/user/domain/user.dart';
part 'user_repository.g.dart';

class UserRepository {
  UserRepository();
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<User?> getUser(String id) async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await _firestore.collection('users').doc(id).get();

    if (userSnapshot.exists) {
      // Parse Firestore document into a User object using the fromJson method
      return User.fromJson(userSnapshot.data()!);
    } else {
      // User not found
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(FirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository();
}
