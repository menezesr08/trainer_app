import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;
  final Widget? item;

  ChatMessage(
      {required this.text,
      required this.isSentByMe,
      required this.timestamp,
      this.item});
}
