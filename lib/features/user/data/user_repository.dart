import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trainer_app/constants/enums.dart';
import 'package:trainer_app/features/onboarding/data/models/onboarding_data.dart';

import 'package:trainer_app/features/user/domain/app_user.dart';

class UserRepository {
  UserRepository(this._firestore);
  final FirebaseFirestore _firestore;

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

  Future<void> setOnboardingData(String id, OnboardingData data) async {
    _userCollection.doc(id).set({
      'age': data.age,
      'bodyWeight': data.bodyWeight,
      'gender': genderToStringMap[data.gender],
      'user_preferences': data.preferences?.toJson(),
    }, SetOptions(merge: true));
  }
}
