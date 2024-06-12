import 'package:flutter/material.dart';
import 'package:trainer_app/features/plans/domain/flow.dart';

class ChatFlowsManager {
  final Map<String, ChatFlow> flows;
  late ChatFlow currentFlow;

  ChatFlowsManager({required this.flows});

  void startFlow(String flowName) {
    currentFlow = flows[flowName]!;
  }

  void addQuestion(String question, Widget widget) {
    currentFlow.questions.insert(0, {'question': question, 'widget': widget});
  }
}

