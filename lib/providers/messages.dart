import 'package:e_learning/models/http_exception.dart';
import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Messages with ChangeNotifier {
  List<Message> items = [];

  List<Message> get messages {
    return [...items];
  }

  Future<void> fetchMessages({teacherId}) async {
    var url = '${mainUrl}chat/messages/$teacherId';
    final prefs = await SharedPreferences.getInstance();
    final token= prefs.getString("userToken");
    try {
      final res = await http.get(Uri.parse(url),headers: {"Authorization":"Bearer $token"});
      final extracted = json.decode(res.body);
      final extractedData = extracted['data'];
      print("msgs:$extractedData");
      if (extractedData == null) {
        return;
      }
      final List<Message> loadedItems = [];
      for (var item in extractedData) {
        loadedItems.add(Message(
          id: int.parse(item['id'].toString()),
          roomId: int.parse(item['room_id'].toString()),
          senderId: int.parse(item['sender_id'].toString()),
          senderName: item['sender_name'].toString(),
          content: item['message'].toString(),
          time: item['created_at'].toString(),
        ));
      }
      items = loadedItems;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }
  // get messages of pusher
  Future<void> receiveMessage({required data}) async {
    if(data['message'] != ""){
      items.add(Message(id: data['id'], roomId: data['room_id'], senderId: data['sender_id'],
          content: data['message'], time: data['created_at'],senderName: data['sender_name']));
      notifyListeners();
    }
  }
  Future<void> addMessage({required String message,required int senderId,required int teacherId}) async {
    if(message != ""){
      var time = DateFormat('hh:mm a').format(DateTime.now());
      items.add(Message(id: 0, roomId: teacherId, senderId: senderId, content: message, time: time,senderName: ""));
      notifyListeners();
      Map mapData ={
        'message': message,
        'senderId': senderId.toString(),
        'teacherId': teacherId.toString(),
      };
      var url = '${mainUrl}chat/messages';
      final prefs = await SharedPreferences.getInstance();
      final token= prefs.getString("userToken");
      try {
        final res = await http.post(Uri.parse(url),body: mapData,headers: {"Authorization":"Bearer $token"});
        final responseData = json.decode(res.body);
        print(responseData);
        if(responseData['errors'] != null){
          throw HttpException(responseData['errors']);
        }
      } catch (err) {
        rethrow;
      }
    }
  }
  // findById
  // Product findById(int id) {
  //   return items.firstWhere((item) => item.id == id);
  // }
}