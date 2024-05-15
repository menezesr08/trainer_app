import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/workouts/domain/base_workout.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';

part 'workouts_repository.g.dart';

class WorkoutsRepository {
  WorkoutsRepository();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<List<BaseWorkout>> getBaseWorkouts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('workouts').get();
    List<BaseWorkout> workouts = [];

    // Iterate over the documents in the query snapshot
    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      // Parse Firestore document into a BaseWorkout object using the fromMap method
      BaseWorkout workout = BaseWorkout.fromMap(document.data());
      workouts.add(workout);
    }

    // Return the list of workouts
    return workouts;
  }

  void addCompletedWorkout(
      String userId, List<CompletedWorkout> completedWorkouts) async {
    try {
      final CollectionReference userCompletedWorkoutsRef = FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .collection('completedWorkouts');

      for (var completedWorkout in completedWorkouts) {
        await userCompletedWorkoutsRef.add(completedWorkout.toMap());
      }

      print('CompletedWorkouts added to Firestore successfully.');
    } catch (error) {
      print('Error adding CompletedWorkouts to Firestore: $error');
    }
  }

  Future<int> generateUniqueId() async {
    final CollectionReference idCounterRef =
        _firestore.collection('workout_id_counter');
    // Get current ID counter document
    DocumentSnapshot docSnapshot = await idCounterRef.doc('counter').get();

    int lastId = 0;

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      lastId = data['last_id'] ?? 0;
    }

    int newId = lastId + 1;

    // Update ID counter document with new ID
    await idCounterRef.doc('counter').set({'last_id': newId});

    return newId;
  }
}

@Riverpod(keepAlive: true)
WorkoutsRepository workoutsRepository(WorkoutsRepositoryRef ref) {
  return WorkoutsRepository();
}
