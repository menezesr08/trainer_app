import 'package:flutter/material.dart';

class CheckInManager {
  final Map<String, CheckInFlow> flows;
  late CheckInFlow currentFlow;

  CheckInManager({required this.flows});

  void startFlow(String flowName) {
    currentFlow = flows[flowName]!;
  }


 void addQuestion(String question, Widget widget) {
    currentFlow.questions.insert(0, {'question': question, 'widget': widget});
  }

}

class CheckInFlow {
  final String name;
  List<Map<String, dynamic>> questions;

  CheckInFlow({required this.name, required this.questions});
}
