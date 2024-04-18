import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

part 'workouts_repository.g.dart';

class WorkoutsRespository {
  const WorkoutsRespository(this._firestore);
  final FirebaseFirestore _firestore;

  static String workout(String uid, String workoutId) =>
      'users/$uid/workouts/$workoutId';
  static String workoutsPath(String uid) => 'users/$uid/workouts';

  // Future<void> addWorkout({required UserID uid, required String name}) async {
  //   final userDocRef = _firestore.collection('users').doc(uid);

  //   final userSnapshot = await userDocRef.get();
  //   if (userSnapshot.exists && userSnapshot.data() != null) {
  //     final data = userSnapshot.data() as Map<String, dynamic>;
  //     final currentWorkouts = data['workouts'] ?? [];

  //     currentWorkouts.add({
  //       'name': name,
  //     });
  //     await userDocRef.update({'workouts': currentWorkouts});
  //   } else {
  //     print('User does not exist');
  //   }
  // }

  Query<Workout> queryAllWorkouts() =>
      _firestore.collection('workouts').withConverter(
            fromFirestore: (snapshot, _) => Workout.fromMap(snapshot.data()!),
            toFirestore: (workout, _) => workout.toMap(),
          );
}

@Riverpod(keepAlive: true)
WorkoutsRespository workoutsRespository(WorkoutsRespositoryRef ref) {
  return WorkoutsRespository(FirebaseFirestore.instance);
}

@riverpod
Query<Workout> allWorkoutsQuery(AllWorkoutsQueryRef ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(workoutsRespositoryProvider);
  return repository.queryAllWorkouts();
}
