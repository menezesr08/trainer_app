import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';

part 'plan_repository.g.dart';

class PlanRepository {
  PlanRepository();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  void addPlanToFirestore(String userId, Plan plan) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('plans')
          .add(plan.toMap());

      print('Plan added to Firestore successfully.');
    } catch (error) {
      print('Error adding plan to Firestore: $error');
    }
  }

  Future<List<Plan>> getPlansFromFirestore(String userId) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the user's plans collection
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('plans')
          .get();

      // Extract plans from the query snapshot
      List<Plan> plans = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Plan.fromMap(data);
      }).toList();

      print(plans.length);

      return plans;
    } catch (error) {
      print(error.toString());
      return [];
    }
  }
}

@Riverpod(keepAlive: true)
PlanRepository planRepository(PlanRepositoryRef ref) {
  return PlanRepository();
}
