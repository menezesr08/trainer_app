import 'package:trainer_app/features/chat/model/chat_message.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  bool enableNextButton;
  final int workoutRating;
  final int sleepRating;
  final int dietRating;
  final String? workoutReason;
  final String? sleepReason;
  final String? dietReason;

  ChatState(
      {required this.messages,
      required this.isLoading,
      required this.workoutRating,
      required this.sleepRating,
      required this.dietRating,
      required this.workoutReason,
      required this.sleepReason,
      required this.dietReason,
      required this.enableNextButton});

  ChatState copyWith(
      {List<ChatMessage>? messages,
      bool? isLoading,
      int? workoutRating,
      int? sleepRating,
      int? dietRating,
      String? workoutReason,
      String? sleepReason,
      String? dietReason,
      bool? enableNextButton}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      workoutRating: workoutRating ?? this.workoutRating,
      sleepRating: sleepRating ?? this.sleepRating,
      dietRating: dietRating ?? this.dietRating,
      workoutReason: workoutReason ?? this.workoutReason,
      sleepReason: sleepReason ?? this.sleepReason,
      dietReason: dietReason ?? this.dietReason,
      enableNextButton: enableNextButton ?? this.enableNextButton,
    );
  }
}
