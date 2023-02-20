import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/course.dart';
import 'package:e_learning/providers/message.dart';
import 'package:e_learning/providers/teacher.dart';
import 'package:e_learning/providers/video.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Videos with ChangeNotifier {
  List<Video> items = [];

  List<Video> get videos {
    return [...items];
  }

  Future<void> fetchVideos({courseId}) async {
    var url = '${mainUrl}courses/$courseId';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("userToken");
    try {
      final res = await http
          .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
      final extracted = json.decode(res.body);
      final extractedData = extracted['data']['videos'];
      if (extractedData == null) {
        return;
      }
      final List<Video> loadedItems = [];
      for (var item in extractedData) {
        loadedItems.add(Video(
          id: int.parse(item['id'].toString()),
          title: item['title'].toString(),
          ipVideo: item['ip_video'].toString(),
          url: item['uri'].toString(),
        ));
      }
      items = loadedItems;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  // findById
  Video findById(int id) {
    return items.firstWhere((item) => item.id == id);
  }
}
