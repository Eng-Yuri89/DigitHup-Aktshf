import 'package:flutter/foundation.dart';

class Course with ChangeNotifier {
  final int id;
  final int videosNum;
  final String name;
  final String image;
  final String cover;
  final String description;

  Course({
    required this.id,
    required this.videosNum,
    required this.name,
    required this.image,
    required this.cover,
    required this.description,
  });
}
