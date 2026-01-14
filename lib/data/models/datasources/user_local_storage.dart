import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorage {
  static const String _userKey = 'users';

  static Future<void> saveUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final users = prefs.getStringList(_userKey) ?? [];

    users.add(jsonEncode({
      'email': email,
      'password': password,
    }));

    await prefs.setStringList(_userKey, users);
  }

  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_userKey) ?? [];

    for (var user in users) {
      final decoded = jsonDecode(user);
      if (decoded['email'] == email &&
          decoded['password'] == password) {
        return true;
      }
    }
    return false;
  }
}
