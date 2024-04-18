import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:trainer_app/features/authentication/domain/app_user.dart';
import 'package:trainer_app/features/trainer/programme/domain/programme.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

part 'programme_repository.g.dart';

class ProgrammeRepository {
  const ProgrammeRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> addProgramme(
      {required UserID uid,
      required String name,
      required List<Workout> workouts}) async {
    final userDocRef = _firestore.collection('users').doc(uid);
    final userSnapshot = await userDocRef.get();
    if (userSnapshot.exists && userSnapshot.data() != null) {
      final data = userSnapshot.data() as Map<String, dynamic>;
      final programmes = data['programmes'] as List<Programme>;

      programmes.add(Programme(name: name, workouts: workouts));
      await userDocRef.update({'programmes': programmes});
    }
  }
}

@Riverpod(keepAlive: true)
ProgrammeRepository programmeRepository(ProgrammeRepositoryRef ref) {
  return ProgrammeRepository(FirebaseFirestore.instance);
}
