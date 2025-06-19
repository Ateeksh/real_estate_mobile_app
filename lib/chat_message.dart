import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final List<String>? options;

  ChatMessage({required this.text, this.isUser = false, this.options});
}
