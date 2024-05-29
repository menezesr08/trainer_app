import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/profile/providers.dart';
import 'package:trainer_app/features/user/domain/app_user.dart';
part 'user_repository.g.dart';

class UserRepository {
  UserRepository();
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _userCollection =>
      _firestore.collection('users');

  Future<AppUser?> getUser(String id) async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await _userCollection.doc(id).get();

    if (userSnapshot.exists) {
      // Parse Firestore document into a User object using the fromJson method
      return AppUser.fromJson(userSnapshot.data()!);
    } else {
      // User not found
      return null;
    }
  }

  Future<void> setUser(AppUser user) async {
    _userCollection.doc(user.id).set(user.toMap());
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

@Riverpod(keepAlive: true)
Future<AppUser?> getUser(GetUserRef ref) {
  final userId = ref.watch(authRepositoryProvider).currentUser!.uid;
  final userRepo = ref.watch(userRepositoryProvider);

  ref.watch(profileRefreshProvider);
  return userRepo.getUser(userId);
}
