import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

// import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  // Auth(this._token, this._expiryDate, this._userId);

  bool get isAuth {
    return (token != null);
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    // var url = Uri.parse(
    //     'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB6K3ELFo8y3KxV9xYG3rxiVocvHQ7mYiQ');
    var url = Uri.https('corpex.nostra.atlasrnd.group', '/api/authuser');
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'Username': email,
            'Password': password,
          }),
          headers: {
            "content-type": "application/json",
          });
      // print(jsonDecode(response.body));
      // print('salam sosiiiiis');
      final responseData = jsonDecode(response.body);
      // print('ay tosss');
      // print(responseData['BeautifulAngelssotosafiribolboli']);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // print(responseData);
      _token = responseData['Token'];
      _userId = responseData['BeautifulAngelssotosafiribolboli'].toString();
      _expiryDate = DateTime.now().add(
        const Duration(
          seconds: 120, // int.parse(responseData['expiresIn'])
        ),
      );

      // print(_token);
      // print(_userId);
      // print(_expiryDate);

      _autoLogout();
      // print('object');
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token': _token,
        'userId': userId,
        'expiryDate': _expiryDate.toString(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = jsonDecode(prefs.getString('userData') as String)
        as Map<String, Object>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expiryDate = expiryDate;
    _autoLogout();
    notifyListeners();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    // prefs.clear(); // clear all
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    // print(timeToExpiry);
    _authTimer = Timer(Duration(seconds: timeToExpiry!), logout);
  }
}
