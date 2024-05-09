import 'package:flutter/foundation.dart';

enum Sender { Client, Server }

class Message {
  final DateTime timestamp;
  final String message;
  final Sender sender;
  final bool isImage;
  final Uint8List? imageData;

  Message(
      {required this.timestamp,
      required this.message,
      required this.sender,
      this.isImage = false,
      this.imageData});
}
