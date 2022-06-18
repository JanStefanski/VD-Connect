import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider extends ChangeNotifier {
  Map<String, dynamic> _config = {
    'language': 'en',
    'connectionType': 'Wifi',
    'targetAddress': '',
    'targetPort': '25931',
    'theme': ThemeMode.system,
    'languages': {
      'en': 'English',
      'zh': '中文',
      'pl': 'Polski',
    }
  };

  get config => _config;
  bool _configLoaded = false;

  get configLoaded => _configLoaded;

  // bool get isConnected => false;

  void setConfig(String key, dynamic value) {
    _config[key] = value;
    notifyListeners();
    savePreferences(key, value.toString());
  }

  void savePreferences(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  void loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    for (String key in _config.keys) {
      if (prefs.containsKey(key)) {
        if (prefs.getString(key) != null) {
          if (key == 'theme') {
            _config[key] = prefs.getString(key) == 'ThemeMode.system'
                ? ThemeMode.system
                : (prefs.getString(key) == 'ThemeMode.dark'
                    ? ThemeMode.dark
                    : ThemeMode.light);
          } else {
            _config[key] = prefs.getString(key);
          }
        }
      }
    }
    _configLoaded = true;
    notifyListeners();
  }
}
