import 'package:shared_preferences/shared_preferences.dart';

enum LocalManagerKey { USERNAME, PASSWORD }

extension LocalKeyExtension on LocalManagerKey {
  String get val {
    switch (this) {
      case LocalManagerKey.USERNAME:
        return "username";
      case LocalManagerKey.PASSWORD:
        return "password";
      default:
        return "invalid key";
    }
  }
}

class LocalManager {
  static LocalManager? _instance;
  static LocalManager get instance {
    if (_instance == null) {
      _instance = LocalManager._init();
    }
    return _instance!;
  }

  SharedPreferences? prefs;
  LocalManager._init();
  Future<void> setString(LocalManagerKey key, String val) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    prefs!.setString(key.val, val);
  }

  Future<String> getString(LocalManagerKey key) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs!.getString(key.val) ?? '';
  }
}
