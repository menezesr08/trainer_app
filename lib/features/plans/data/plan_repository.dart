import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';
import 'package:trainer_app/features/workouts/domain/workout.dart';

part 'plan_repository.g.dart';

class PlanRepository {
  PlanRepository();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  void addPlanToFirestore(Plan plan, String userId,
      List<Workout> workoutsToSave) async {
    final id = plan.id ?? await generateUniqueId();

    Plan newOrUpdatedPlan = Plan(
      id: id,
      name: plan.name,
      workouts: workoutsToSave,
      scheduledAt: plan.scheduledAt,
      isRecurring: plan.isRecurring,
      recurringType: plan.recurringType
    );
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('plans')
          .doc(newOrUpdatedPlan.id.toString())
          .set(newOrUpdatedPlan.toMap());

      print('Plan added to Firestore successfully.');
    } catch (error) {
      print('Error adding plan to Firestore: $error');
    }
  }

  void deletePlan(int planId, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('plans')
          .doc(planId.toString())
          .delete();

      print('Plan deleted');
    } catch (error) {
      print('Error delete plan to Firestore: $error');
    }
  }

  Future<int> generateUniqueId() async {
    final CollectionReference idCounterRef =
        _firestore.collection('plan_id_counter');
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

  Stream<List<Plan>> getPlansFromFirestore(String userId) {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the user's plans collection and listen for real-time updates
      return firestore
          .collection('users')
          .doc(userId)
          .collection('plans')
          .snapshots()
          .map((querySnapshot) {
        // Extract plans from the query snapshot
        return querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Plan.fromMap(data);
        }).toList();
      });
    } catch (error) {
      print(error.toString());
      return Stream.value([]); // Return an empty stream in case of error
    }
  }
}

final getPlansStream = StreamProvider.autoDispose.family<List<Plan>, String>((ref, userId) {
  final plans = ref.watch(planRepositoryProvider);
  return plans.getPlansFromFirestore(userId);
});

@Riverpod(keepAlive: true)
PlanRepository planRepository(PlanRepositoryRef ref) {
  return PlanRepository();
}
