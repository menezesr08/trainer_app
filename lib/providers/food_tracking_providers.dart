
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/food_tracking/data/food_tracking_repository.dart';

 part 'food_tracking_providers.g.dart';

@Riverpod(keepAlive: true)
FoodTrackingRepository foodTrackingRepository(FoodTrackingRepositoryRef ref) {
  return FoodTrackingRepository();
}
