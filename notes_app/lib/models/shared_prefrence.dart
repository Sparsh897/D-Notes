import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveAccessToken(String accessToken) async {
    await _preferences.setString('accessToken', accessToken);
  }

  static String? getAccessToken() {
    return _preferences.getString('accessToken');
  }

  static Future<void> clearAccessToken() async {
    await _preferences.remove('accessToken');
  }
}
