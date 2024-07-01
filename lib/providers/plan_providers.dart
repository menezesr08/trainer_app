import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/plans/data/plan_repository.dart';
import 'package:trainer_app/features/plans/domain/plan.dart';
import 'package:trainer_app/providers/firestore_providers.dart';
part 'plan_providers.g.dart';

final getPlansStream =
    StreamProvider.autoDispose.family<List<Plan>, String>((ref, userId) {
  final plans = ref.watch(planRepositoryProvider);
  return plans.getPlansFromFirestore(userId);
});

@Riverpod(keepAlive: true)
PlanRepository planRepository(PlanRepositoryRef ref) {
  return PlanRepository(ref.watch(firestoreProvider));
}
