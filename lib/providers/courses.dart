import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/course.dart';
import 'package:e_learning/providers/message.dart';
import 'package:e_learning/providers/teacher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Courses with ChangeNotifier {
  List<Course> items = [];

  List<Course> get courses {
    return [...items];
  }

  Future<void> fetchCourses({teacherId}) async {
    var url = '${mainUrl}teachers/$teacherId';
    final prefs = await SharedPreferences.getInstance();
    final token= prefs.getString("userToken");
    try {
      final res = await http.get(Uri.parse(url),headers: {"Authorization":"Bearer $token"});
      final extracted = json.decode(res.body);
      final extractedData = extracted['data']['courses'];
      if (extractedData == null) {
        return;
      }
      final List<Course> loadedItems = [];
      for (var item in extractedData) {
        loadedItems.add(Course(
          id: int.parse(item['id'].toString()),
          name: item['title'].toString(),
          image: item['image'].toString(),
          cover: item['cover'].toString(),
          //image: "assets/images/course_avatar.png",
          description: item['min_description'].toString(),
          videosNum: int.parse(item['videosCount'].toString()),
        ));
      }
      items = loadedItems;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }
  // findById
  Course findById(int id) {
    return items.firstWhere((item) => item.id == id);
  }
}