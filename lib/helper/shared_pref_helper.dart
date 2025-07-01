import 'package:catering_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static final String _loginKey = "login";
  static final String _tokenKey = "token";
  static final String _nameKey = "name";
  static final String _emailKey = "email";
  static final String _createdAtKey = "created_at";

  static Future<void> setLogin(bool login) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loginKey, login);
  }

  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  static Future<void> deleteLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_loginKey);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenKey, token);
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? "";
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenKey);
  }

  static Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_nameKey, user.name!);
    prefs.setString(_emailKey, user.email!);
    prefs.setString(_createdAtKey, user.createdAt!.toString());
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_nameKey);
    final email = prefs.getString(_emailKey);
    final createdAt = prefs.getString(_createdAtKey);
    return {"name": name, "email": email, "created_at": createdAt};
  }

  static Future<void> deleteUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_nameKey);
    prefs.remove(_emailKey);
    prefs.remove(_createdAtKey);
  }
}
