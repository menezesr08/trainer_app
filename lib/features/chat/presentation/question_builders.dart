import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/chat/model/model.dart';
import 'package:trainer_app/features/chat/providers.dart';
import 'package:trainer_app/features/plans/domain/chat_flows_manager.dart';
import 'package:trainer_app/features/chat/presentation/ratings_bar.dart';
import 'package:trainer_app/features/chat/presentation/selectable_options.dart';

class QuestionBuilders {
  final WidgetRef ref;
  final ChatFlowsManager chatFlowsManager;
  final OpenAI openAI;
  final List<String> ratingsLabel;

  QuestionBuilders(
      this.ref, this.chatFlowsManager, this.openAI, this.ratingsLabel);

  Map<String, dynamic> buildWorkoutQuestion() {
    return _buildQuestion(
      "How were your workouts this week?",
      Consumer(builder: (context, ref, child) {
        final workoutRating = ref.watch(chatProvider).workoutRating;

        return RatingBar(
          selectedOption: workoutRating,
          ratingLabels: ratingsLabel,
          onRatingChanged: (v) {
            ref.read(chatProvider.notifier).updateWorkoutRating(v);
            if (v - 1 < 2) {
              const type = 'fitness';
              chatFlowsManager
                  .addQuestion('What do you think is the main reason for this?',
                      Consumer(builder: (context, ref, child) {
                final workoutReason = ref.watch(chatProvider).workoutReason;
                print( 'read consumer $workoutReason');
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
                  selectedOption: workoutReason,
                  onOptionSelected: (v) async {
                       print('onOptionSelected $v');
                    ref.read(chatProvider.notifier).updateWorkoutReason(v);
                    ref.read(chatProvider.notifier).printState();
                    await _standardCHATGPTResponse(
                        'Give me 3 solutions for $v - short answer');
                    askCheckInQuestion();
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
        final sleepRating = ref.watch(chatProvider).sleepRating;
        final sleepReason = ref.watch(chatProvider).sleepReason;
        return RatingBar(
          selectedOption: sleepRating,
          ratingLabels: ratingsLabel,
          onRatingChanged: (v) {
            ref.read(chatProvider.notifier).updateSleepRating(v);
            if (v - 1 < 2) {
              const type = 'lack_of_sleep';
              chatFlowsManager
                  .addQuestion('What do you think is the main reason for this?',
                      Consumer(builder: (context, ref, child) {
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
                  selectedOption: sleepReason,
                  onOptionSelected: (v) async {
                    ref.read(chatProvider.notifier).updateSleepReason(v);
                    await _standardCHATGPTResponse(
                        'Give me 3 solutions for $v - short answer');
                    askCheckInQuestion();
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
        final dietRating = ref.watch(chatProvider).dietRating;
        final dietReason = ref.watch(chatProvider).dietReason;
        return RatingBar(
          selectedOption: dietRating,
          ratingLabels: ratingsLabel,
          onRatingChanged: (v) {
            ref.read(chatProvider.notifier).updateDietRating(v);
            if (v - 1 < 2) {
              const type = 'poor_diet';
              chatFlowsManager
                  .addQuestion('What do you think is the main reason for this?',
                      Consumer(builder: (context, ref, child) {
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
                  selectedOption: dietReason,
                  onOptionSelected: (v) async {
                    ref.read(chatProvider.notifier).updateDietReason(v);
                    await _standardCHATGPTResponse(
                        'Give me 3 solutions for $v - short answer');
                    askCheckInQuestion();
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

  Future<void> _standardCHATGPTResponse(String text) async {
    final request = ChatCompleteText(
      messages: [Messages(role: Role.user, content: text)],
      maxToken: 200,
      model:
          ChatModelFromValue(model: 'ft:gpt-3.5-turbo-0613:personal::9KMlAHyw'),
    );
    ref.read(chatProvider.notifier).setLoading(true);
    final response = await openAI.onChatCompletion(request: request);

    ChatMessage message = ChatMessage(
      text: response!.choices.first.message!.content.trim(),
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    ref.read(chatProvider.notifier).setLoading(false);

    ref.read(chatProvider.notifier).addMessage(message);
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

      ref.read(chatProvider.notifier).addMessage(message);
    } else {
      ChatMessage message = ChatMessage(
        text: 'Thanks for checking in! Have a great day',
        isSentByMe: false,
        timestamp: DateTime.now(),
      );

      ref.read(chatProvider.notifier).addMessage(message);
    }
  }
}
