
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/chat/data/chat_provider.dart';

import 'package:trainer_app/features/chat/model/chat_state.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
