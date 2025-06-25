import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static String _loginKey = "login";

  Future<void> setLogin(bool login) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loginKey, login);
  }

  Future<void> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getBool(_loginKey);
  }

  Future<void> deleteLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_loginKey);
  }

  
}
