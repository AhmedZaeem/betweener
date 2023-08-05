import 'package:shared_preferences/shared_preferences.dart';

import '../enums.dart';

Future<String> getToken() async {
  return await CachedController().getData(sharedPrefKeys.token);
}

class CachedController {
  CachedController._();
  static CachedController cache = CachedController._();
  factory CachedController() => cache;
  late SharedPreferences preferences;
  Future<void> initCache() async {
    preferences = await SharedPreferences.getInstance();
  }

  dynamic getData(sharedPrefKeys key) {
    return preferences.get(key.name);
  }

  Future<void> setData(sharedPrefKeys key, dynamic data) async {
    if (data is String) {
      await preferences.setString(key.name, data);
    } else if (data is bool) {
      await preferences.setBool(key.name, data);
    } else if (data is int) {
      await preferences.setInt(key.name, data);
    } else if (data is double) {
      await preferences.setDouble(key.name, data);
    }
  }
}
