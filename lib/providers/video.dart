import 'package:flutter/foundation.dart';

class Video with ChangeNotifier {
  final int id;
  final String title;
  final String url;
  final String ipVideo;

  Video({
    required this.id,
    required this.title,
    required this.ipVideo,
    required this.url,
  });
}
