import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/course.dart';
import 'package:e_learning/providers/meeting.dart';
import 'package:e_learning/providers/message.dart';
import 'package:e_learning/providers/teacher.dart';
import 'package:e_learning/providers/video.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Meetings with ChangeNotifier {
  List<Meeting> publicItems = [];
  List<Meeting> privateItems = [];

  List<Meeting> get publicMeetings {
    return [...publicItems];
  }

  List<Meeting> get privateMeetings {
    return [...privateItems];
  }

  Future<void> fetchMeetings() async {
    var url = '${mainUrl}meetings';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("userToken");
    try {
      final res = await http.get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
      final extracted = json.decode(res.body);
      final extractedData = extracted['data'];
      if (extractedData == null) {
        return;
      }
      final List<Meeting> loadedPublicItems = [];
      final List<Meeting> loadedPrivateItems = [];
      for (var item in extractedData) {
        if(item['type'].toString() == 'public'){
          loadedPublicItems.add(Meeting(
            id: int.parse(item['id'].toString()),
            meetingId: item['meetingId'].toString(),
            meetingPassword: item['meetingPassword'].toString(),
            password: item['password'].toString(),
            startAt: item['startAt'].toString(),
            type: item['type'].toString(),
            time: item['duration'].toString(),
            status: item['situation'].toString(),
            description: item['topic'].toString(),
            teacherName: item['teacher']['name'].toString(),
          ));
        }
        else if(item['type'].toString() == 'private'){
          loadedPrivateItems.add(Meeting(
            id: int.parse(item['id'].toString()),
            meetingId: item['meetingId'].toString(),
            meetingPassword: item['meetingPassword'].toString(),
            password: item['password'].toString(),
            startAt: item['startAt'].toString(),
            type: item['type'].toString(),
            time: item['duration'].toString(),
            status: item['situation'].toString(),
            description: item['topic'].toString(),
            teacherName: item['teacher']['name'].toString(),
          ));
        }
      }
      publicItems = loadedPublicItems;
      privateItems = loadedPrivateItems;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  // findById
  Meeting findPublicById(int id) {
    return publicItems.firstWhere((item) => item.id == id);
  }
  // findById
  Meeting findPrivateById(int id) {
    return privateItems.firstWhere((item) => item.id == id);
  }
}
