import 'dart:async';
import 'dart:convert';
import 'package:e_learning/models/http_exception.dart';
import 'package:e_learning/models/main_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier{
  String _token = '';
  int _userId = 0;
  Map<String,dynamic> authData = {
    'name': '',
  };

  bool get isAuth{
    return (_token != '');
  }
  String get token{
    return _token;
  }
  int get userId{
    return _userId;
  }
  // login
  Future<void> login({required String email, required String password}) async{
    Map mapData ={
      'email': email,
      'password': password,
    };
    final url='${mainUrl}login';
    try{
      final res = await http.post(Uri.parse(url),body: mapData);
      final responseData = json.decode(res.body);
      // if(responseData['message'] != null){
      //   throw HttpException(responseData['message']);
      // }
      if(responseData['success'] == false){
        throw HttpException("يوجد خطأ في بيانات الدخول");
      }
      _token = responseData["data"]['token'];
      authData['name'] = responseData["data"]['name']['name'];
      _userId = responseData["data"]['name']['id'];
      notifyListeners();
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('userToken',_token);
    }catch(e){
      rethrow;
    }
  }
  // signup
  Future<void> signUp({required String name,required String password,required String email}) async{
    Map mapData ={
      'name': name,
      'password': password,
      'email': email,
    };
    final url='${mainUrl}register';
    try{
      final res = await http.post(Uri.parse(url),body: mapData);
      final responseData = json.decode(res.body);
      if(responseData['success'] == false){
        throw HttpException(responseData['data']['email'][0]);
      }
      _token = responseData["data"]['token'];
      authData['name'] = responseData["data"]['user']['name'];
      _userId = responseData["data"]['user']['id'];
      notifyListeners();
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('userToken',_token);
    }catch(e){
      rethrow;
    }
  }
  // reset password
  Future<void> resetPassword({required String email}) async{
    Map mapData ={
      'email': email,
    };
    final url='${mainUrl}password/email';
    try{
      final res = await http.post(Uri.parse(url),body: mapData);
      //final responseData = json.decode(res.body);
      final statusCode = res.statusCode;
      String msg = "لم يتم العثور على أيّ حسابٍ بهذا العنوان الإلكتروني";
      //print("stats:${res.statusCode}");
      if(statusCode != 200){
        throw HttpException(msg);
      }else{
        throw HttpException("done");
      }
    }catch(e){
      rethrow;
    }
  }
  // auto login
  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("userToken")) return false;
    _token = prefs.getString("userToken")!;
    final url='${mainUrl}user';
    final token= prefs.getString("userToken");
    try{
      final res = await http.get(Uri.parse(url),headers: {"Authorization":"Bearer $token"});
      final responseData = json.decode(res.body);
      _userId = responseData['data']['id'];
      authData['name'] = responseData["data"]['name'];
    }catch(e){
      rethrow;
    }
    notifyListeners();
    return true;
  }
  // logout
  Future<void> logout() async{
    _token = '';
    _userId = 0;
    authData = {
      'name': '',
    };
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  // get data
  Future<void> getData() async{
    final url='${mainUrl}user';
    final prefs = await SharedPreferences.getInstance();
    final token= prefs.getString("userToken");
    try{
      final res = await http.get(Uri.parse(url),headers: {"Authorization":"Bearer $token"});
      final responseData = json.decode(res.body);
      print(responseData);
    }catch(e){
      rethrow;
    }
  }
  // delete account
  Future<void> deleteAccount () async{
    final url='${mainUrl}delete';
    //
    final prefs = await SharedPreferences.getInstance();
    final token= prefs.getString("userToken");
    //
    await http.post(Uri.parse(url),headers: {"Authorization":"Bearer $token"});
  }
}