import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static final String _loginKey = "login";
  static final String _tokenKey = "token";

  static Future<void> setLogin(bool login) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loginKey, login);
  }

  static Future<void> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getBool(_loginKey);
  }

  static Future<void> deleteLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_loginKey);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenKey, token);
  }

  static Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString(_tokenKey);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenKey);
  }
}
