

import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'profile_providers.g.dart';

@Riverpod(keepAlive: true)
class ProfileRefreshNotifier extends _$ProfileRefreshNotifier {
  @override
  bool build() => false;

  void refresh() => state = !state;
}