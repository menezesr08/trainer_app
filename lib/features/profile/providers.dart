
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileRefreshNotifier extends StateNotifier<bool> {
  ProfileRefreshNotifier() : super(false);

  void refresh() => state = !state;
}

final profileRefreshProvider = StateNotifierProvider<ProfileRefreshNotifier, bool>((ref) {
  return ProfileRefreshNotifier();
});
