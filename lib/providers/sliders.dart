import 'package:e_learning/models/main_data.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Sliders with ChangeNotifier {
  List slides =[];
  Future<void> fetchSlides() async {
    var url = '${mainUrl}sliders';
    try {
      final res = await http.get(Uri.parse(url));
      final extracted = json.decode(res.body);
      final extractedData = extracted['data'];
      if (extractedData == null) {
        return;
      }
      for (var item in extractedData) {
        slides.add(item['imageUrl']);
      }
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }
}
