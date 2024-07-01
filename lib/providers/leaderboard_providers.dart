// Providers for LeaderboardRepository
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainer_app/features/leaderboard/data/leaderboard_repository.dart';
import 'package:trainer_app/providers/firestore_providers.dart';
part 'leaderboard_providers.g.dart';

@riverpod
LeaderboardRepository leaderboardRepository(LeaderboardRepositoryRef ref) {
  final firestore = ref.watch(firestoreProvider);
  return LeaderboardRepository(firestore);
}

@riverpod
Future<List<Map<String, dynamic>>> globalLeaderboard(GlobalLeaderboardRef ref) async {
  final repository = ref.watch(leaderboardRepositoryProvider);
  return await repository.fetchGlobalLeaderboard();
}

@riverpod
Future<List<Map<String, dynamic>>> localLeaderboard(LocalLeaderboardRef ref, String userID) async {
  final repository = ref.watch(leaderboardRepositoryProvider);
  return await repository.fetchLocalLeaderboard(userID);
}