import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/teacher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Teachers with ChangeNotifier {
  List<Teacher> items = [];

  List<Teacher> get teachers {
    return [...items];
  }

  Future<void> fetchTeachers() async {
    var url = '${mainUrl}teachers';
    final prefs = await SharedPreferences.getInstance();
    final token= prefs.getString("userToken");
    try {
      final res = await http.get(Uri.parse(url),headers: {"Authorization":"Bearer $token"});
      final extracted = json.decode(res.body);
      final extractedData = extracted['data'];
      if (extractedData == null) {
        return;
      }
      final List<Teacher> loadedItems = [];
      for (var item in extractedData) {
        loadedItems.add(Teacher(
          id: int.parse(item['id'].toString()),
          name: item['name'].toString(),
          image: item['image'].toString(),
          cover: item['cover'].toString(),
          description: item['description'].toString(),
          subject: item['field'] != null ? item['field'].toString() : 'تخصص عام',
          coursesNumber: int.parse(item['coursesCount'].toString()),
        ));
      }
      items = loadedItems;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }
  // findById
  Teacher findById(int id) {
    return items.firstWhere((item) => item.id == id);
  }
}