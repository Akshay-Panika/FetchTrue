import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession extends ChangeNotifier {
  String? _userId;
  String? _token;
  String? _name;
  String? _phone;
  String? _email;
  String? _loginDate;
  bool _isInitialized = false;

  String? get userId => _userId;
  String? get token => _token;
  String? get name => _name;
  String? get phone => _phone;
  String? get email => _email;
  String? get loginDate => _loginDate;
  bool get isLoggedIn => _userId != null && _token != null;
  bool get isInitialized => _isInitialized;

  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    _token = prefs.getString('token');
    _name = prefs.getString('name');
     _phone = prefs.getString('phone');
    _email = prefs.getString('email');
    _loginDate = prefs.getString('loginDate');
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> login(
      String userId, String token, String name, String phone, String email, String date) async {
    _userId = userId;
    _token = token;
    _name = name;
    _phone = phone;
    _email = email;
    _loginDate = date;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('phone', phone);
    await prefs.setString('email', email);
    await prefs.setString('loginDate', date);
    notifyListeners();
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    _name = null;
    _email = null;
    _loginDate = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
