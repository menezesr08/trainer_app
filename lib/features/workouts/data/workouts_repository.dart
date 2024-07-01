import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/workouts/domain/base_workout.dart';
import 'package:trainer_app/features/workouts/domain/completed_workout.dart';
import 'package:trainer_app/providers/auth_providers.dart';

part 'workouts_repository.g.dart';

class WorkoutsRepository {
  WorkoutsRepository();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  CollectionReference get userCollection => _firestore.collection('users');
  CollectionReference get workoutIdCounter => _firestore.collection('workout_id_counter');

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
      final CollectionReference userCompletedWorkoutsRef = userCollection
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

    DocumentSnapshot docSnapshot = await workoutIdCounter.doc('counter').get();

    int lastId = 0;

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      lastId = data['last_id'] ?? 0;
    }

    int newId = lastId + 1;

    // Update ID counter document with new ID
    await workoutIdCounter.doc('counter').set({'last_id': newId});

    return newId;
  }

  Stream<List<CompletedWorkout>> getCompletedWorkoutsFromFirestore(
      String userId) {
    try {
      return userCollection
          .doc(userId)
          .collection('completedWorkouts')
          .snapshots()
          .map((querySnapshot) {
        // Extract plans from the query snapshot
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return CompletedWorkout.fromMap(data);
        }).toList();
      });
    } catch (error) {
      print(error.toString());
      return Stream.value([]); // Return an empty stream in case of error
    }
  }
}

final baseWorkoutsProvider = FutureProvider<List<BaseWorkout>>((ref) async {
  final workoutsRepository = ref.read(workoutsRepositoryProvider);
  return workoutsRepository.getBaseWorkouts();
});

final completedWorkoutsProvider = StreamProvider<List<CompletedWorkout>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userId = authRepository.currentUser!.uid;
  final workoutsRepository = ref.read(workoutsRepositoryProvider);
  return workoutsRepository.getCompletedWorkoutsFromFirestore(userId);
});

@Riverpod(keepAlive: true)
WorkoutsRepository workoutsRepository(WorkoutsRepositoryRef ref) {
  return WorkoutsRepository();
}
