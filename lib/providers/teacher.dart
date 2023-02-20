import 'package:flutter/foundation.dart';

class Teacher with ChangeNotifier {
  final int id;
  final int coursesNumber;
  final String name;
  final String image;
  final String description;
  final String cover;
  final String subject;

  Teacher({
    required this.id,
    required this.coursesNumber,
    required this.name,
    required this.image,
    required this.description,
    required this.cover,
    required this.subject,
  });
}
