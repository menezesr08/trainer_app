import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trainer_app/features/chat/model/chat_message.dart';
import 'package:trainer_app/features/chat/model/chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier()
      : super(ChatState(
          messages: [],
          isLoading: false,
          workoutRating: 0,
          sleepRating: 0,
          dietRating: 0,
          workoutReason: null,
          sleepReason: null,
          dietReason: null,
          enableNextButton: false,
        ));

  void addMessage(ChatMessage message) {
    state = state.copyWith(
      messages: [message, ...state.messages],
    );
  }

  Future<bool> clearState() async {
    state = state.copyWith(
      messages: [],
      isLoading: false,
      workoutRating: 0,
      sleepRating: 0,
      dietRating: 0,
      workoutReason: null,
      sleepReason: null,
      dietReason: null,
      enableNextButton: false,
    );

    return true;
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setEnableNextButton(bool enableNextButton) {
    state = state.copyWith(enableNextButton: enableNextButton);
  }

  void updateWorkoutRating(int rating) {
    state = state.copyWith(workoutRating: rating);
  }

  void updateSleepRating(int rating) {
    state = state.copyWith(sleepRating: rating);
  }

  void updateDietRating(int rating) {
    state = state.copyWith(dietRating: rating);
  }

  void updateWorkoutReason(String reason) {
    state = state.copyWith(workoutReason: reason);
  }

  void updateSleepReason(String reason) {
    state = state.copyWith(sleepReason: reason);
  }

  void updateDietReason(String reason) {
    state = state.copyWith(dietReason: reason);
  }

  void printState() {
    print("workoutRating: ${state.workoutRating}");
    print("sleepRating: ${state.sleepRating}");
    print("dietRating: ${state.dietRating}");
    print("workoutReason: ${state.workoutReason}");
    print("sleepReason: ${state.sleepReason}");
    print("dietReason: ${state.dietReason}");
  }
}
