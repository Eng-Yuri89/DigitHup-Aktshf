import 'package:flutter/foundation.dart';

class Message with ChangeNotifier {
  final int id;
  final int roomId;
  final int senderId;
  final String senderName;
  final String content;
  final String time;

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.time,
  });
}
