import 'package:flutter/foundation.dart';

class Meeting with ChangeNotifier {
  final int id;
  final String password;
  final String meetingId;
  final String meetingPassword;
  final String type;
  final String startAt;
  final String time;
  final String status;
  final String description;
  final String teacherName;

  Meeting({
    required this.id,
    required this.password,
    required this.meetingId,
    required this.meetingPassword,
    required this.type,
    required this.startAt,
    required this.time,
    required this.status,
    required this.description,
    required this.teacherName,
  });
}
