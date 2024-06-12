import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/chat/model/model.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final int workoutRating;
  final int sleepRating;
  final int dietRating;
  final String? workoutReason;
  final String? sleepReason;
  final String? dietReason;

  ChatState({
    required this.messages,
    required this.isLoading,
    required this.workoutRating,
    required this.sleepRating,
    required this.dietRating,
    required this.workoutReason,
    required this.sleepReason,
    required this.dietReason,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    int? workoutRating,
    int? sleepRating,
    int? dietRating,
    String? workoutReason,
    String? sleepReason,
    String? dietReason,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      workoutRating: workoutRating ?? this.workoutRating,
      sleepRating: sleepRating ?? this.sleepRating,
      dietRating: dietRating ?? this.dietRating,
      workoutReason: workoutReason,
      sleepReason: sleepReason,
      dietReason: dietReason,
    );
  }
}

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
    );

    return true;
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
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

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
