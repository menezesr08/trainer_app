import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/chat/model/chat_message.dart';
import 'package:trainer_app/features/chat/data/chat_provider.dart';
import 'package:trainer_app/features/chat/model/chat_state.dart';
import 'package:trainer_app/features/plans/domain/chat_flows_manager.dart';
import 'package:trainer_app/features/chat/presentation/ratings_bar.dart';
import 'package:trainer_app/features/chat/presentation/selectable_options.dart';
import 'package:trainer_app/providers/chat_provider.dart';

class QuestionBuilders {
  final WidgetRef ref;
  final ChatFlowsManager chatFlowsManager;
  final OpenAI openAI;
  final List<String> ratingsLabel;
  final Future<void> Function(String) standardCHATGPTResponse;

  late ChatNotifier chatNotifier;
  late ChatState chatState;

  QuestionBuilders(this.ref, this.chatFlowsManager, this.openAI,
      this.ratingsLabel, this.standardCHATGPTResponse) {
    chatNotifier = ref.read(chatProvider.notifier);
    chatState = ref.watch(chatProvider);
  }

  Map<String, dynamic> buildWorkoutQuestion() {
    return _buildQuestion(
      "How were your workouts this week?",
      Consumer(builder: (context, ref, child) {
        chatNotifier = ref.read(chatProvider.notifier);
        chatState = ref.watch(chatProvider);
        return RatingBar(
          selectedOption: chatState.workoutRating,
          ratingLabels: ratingsLabel,
          onRatingChanged: (v) {
            chatNotifier.updateWorkoutRating(v);
            chatNotifier.printState();
            if (v - 1 < 2) {
              const type = 'fitness';
              chatFlowsManager
                  .addQuestion('What do you think is the main reason for this?',
                      Consumer(builder: (context, ref, child) {
                chatNotifier = ref.read(chatProvider.notifier);
                chatState = ref.watch(chatProvider);
                return SelectableOptions(
                  options: [
                    SelectableOption(
                      label: 'Lack of Sleep',
                      value: '${type}_lack_of_sleep',
                    ),
                    SelectableOption(
                        label: 'Poor Nutrition',
                        value: '${type}_poor_nutrition'),
                    SelectableOption(
                        label: 'No Warm-Up', value: '${type}_no_warm_up'),
                    SelectableOption(
                        label: 'Mental Stress', value: '${type}_mental_stress'),
                    SelectableOption(
                        label: 'Overtraining', value: '${type}_overtraining'),
                  ],
                  selectedOption: chatState.workoutReason,
                  onOptionSelected: (v) async {
                    chatNotifier.updateWorkoutReason(v);
                    chatNotifier.printState();
                    await standardCHATGPTResponse(
                        'Give me 3 solutions for $v - short answer');
                    chatNotifier.setEnableNextButton(true);
                  },
                );
              }));
            }
            askCheckInQuestion();
          },
        );
      }),
    );
  }

  Map<String, dynamic> buildSleepQuestion() {
    return _buildQuestion(
      "How are you sleeping?",
      Consumer(builder: (context, ref, child) {
        chatNotifier = ref.read(chatProvider.notifier);
        chatState = ref.watch(chatProvider);
        chatNotifier.printState();
        return RatingBar(
          selectedOption: chatState.sleepRating,
          ratingLabels: ratingsLabel,
          onRatingChanged: (v) {
            chatNotifier.updateSleepRating(v);

            if (v - 1 < 2) {
              const type = 'lack_of_sleep';
              chatFlowsManager
                  .addQuestion('What do you think is the main reason for this?',
                      Consumer(builder: (context, ref, child) {
                chatNotifier = ref.read(chatProvider.notifier);
                chatState = ref.watch(chatProvider);
                return SelectableOptions(
                  options: [
                    SelectableOption(
                        label: 'Stress and Anxiety', value: '${type}_stress'),
                    SelectableOption(
                        label: 'Poor Sleep Environment',
                        value: '${type}_poor_environment'),
                    SelectableOption(
                        label: 'Irregular Sleep Schedule',
                        value: '${type}_stress_poor_schedule'),
                    SelectableOption(
                        label: 'Diet and Stimulants',
                        value: '${type}_stimulants'),
                    SelectableOption(
                        label: 'Medical Conditions',
                        value: '${type}_medical_conditions'),
                  ],
                  selectedOption: chatState.sleepReason,
                  onOptionSelected: (v) async {
                    chatNotifier.updateSleepReason(v);
                    await standardCHATGPTResponse(
                        'Give me 3 solutions for $v - short answer');
                    chatNotifier.setEnableNextButton(true);
                  },
                );
              }));
            }
            askCheckInQuestion();
          },
        );
      }),
    );
  }

  Map<String, dynamic> buildDietQuestion() {
    return _buildQuestion(
      "How is your diet?",
      Consumer(builder: (context, ref, child) {
        chatNotifier = ref.read(chatProvider.notifier);
        chatState = ref.watch(chatProvider);
        return RatingBar(
          selectedOption: chatState.dietRating,
          ratingLabels: ratingsLabel,
          onRatingChanged: (v) {
            chatNotifier.updateDietRating(v);
            if (v - 1 < 2) {
              const type = 'poor_diet';
              chatFlowsManager
                  .addQuestion('What do you think is the main reason for this?',
                      Consumer(builder: (context, ref, child) {
                chatNotifier = ref.read(chatProvider.notifier);
                chatState = ref.watch(chatProvider);
                return SelectableOptions(
                  options: [
                    SelectableOption(
                        label: 'Convenience', value: '${type}_convenience'),
                    SelectableOption(
                        label: 'Busy Lifestyle',
                        value: '${type}_busy_lifestyle'),
                    SelectableOption(
                        label: 'Financial challenges',
                        value: '${type}_financial_challenge'),
                    SelectableOption(
                        label: 'Lack of Education ',
                        value: 'new_recipes_ideas'),
                  ],
                  selectedOption: chatState.dietReason,
                  onOptionSelected: (v) async {
                    chatNotifier.updateDietReason(v);
                    chatNotifier.printState();
                    await standardCHATGPTResponse(
                        'Give me 3 solutions for $v - short answer');
                    chatNotifier.setEnableNextButton(true);
                  },
                );
              }));
            }
            askCheckInQuestion();
          },
        );
      }),
    );
  }

  Map<String, dynamic> _buildQuestion(String question, Widget widget) {
    return {
      'question': question,
      'widget': widget,
    };
  }

  void askCheckInQuestion() {
    if (chatFlowsManager.currentFlow.questions.isNotEmpty) {
      var nextQuestion = chatFlowsManager.currentFlow.questions.removeAt(0);

      ChatMessage message = ChatMessage(
        text: nextQuestion['question'],
        isSentByMe: false,
        timestamp: DateTime.now(),
        item: nextQuestion['widget'],
      );

      chatNotifier.addMessage(message);
    } else {
      ChatMessage message = ChatMessage(
        text: 'Thanks for checking in! Have a great day',
        isSentByMe: false,
        timestamp: DateTime.now(),
      );

      chatNotifier.addMessage(message);
      chatNotifier.printState();
    }
  }
}
