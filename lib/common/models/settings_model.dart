import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting {
  final String key;
  final dynamic defaultValue;
  dynamic value;

  dynamic getValue() {
    return value ?? defaultValue;
  }

  Setting({required this.key, required this.defaultValue, this.value});
}

class SettingsModel extends ChangeNotifier {
  final scriptRepository = Setting(
      key: "script_repository",
      defaultValue: "https://github.com/Ghoelian/adb-manager-scripts.git");
  final reloadInterval =
      Setting(key: "reload_interval_millis", defaultValue: 5 * 1000);
  final rerunTimeout =
      Setting(key: "reconnect_timeout", defaultValue: 10 * 1000);

  bool loading = true;

  SettingsModel() {
    populateSettings();
  }

  Future<void> populateSettings() async {
    loading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    final repoValue = prefs.getString("script_repository");
    final reloadValue = prefs.getInt("reload_interval_millis");
    final rerunValue = prefs.getInt("reconnect_timeout");

    if (repoValue != null) {
      scriptRepository.value = repoValue;
    }

    if (reloadValue != null) {
      reloadInterval.value = reloadValue;
    }

    if (rerunValue != null) {
      rerunTimeout.value = rerunValue;
    }

    loading = false;
    notifyListeners();
  }

  // TODO: fix this mess holy shit this is unreadable
  Future<void> updateSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    switch (key) {
      case "script_repository":
        if (value == null) {
          scriptRepository.value = null;
          notifyListeners();

          await prefs.remove("script_repository");
          return;
        }

        final parsedValue = Uri.tryParse(value);

        if (parsedValue == null) return;

        scriptRepository.value = parsedValue;
        await prefs.setString("script_repository", parsedValue.toString());

        break;
      case "reload_interval_millis":
        if (value == null) {
          reloadInterval.value = null;
          notifyListeners();

          await prefs.remove("reload_interval_millis");
          return;
        }

        final parsedValue =
            value.runtimeType == int ? value : int.tryParse(value);

        if (parsedValue == null) return;

        reloadInterval.value = parsedValue;
        await prefs.setInt("reload_interval_millis", parsedValue);

        break;
      case "reconnect_timeout":
        if (value == null) {
          rerunTimeout.value = null;
          notifyListeners();

          await prefs.remove("reconnect_timeout");
          return;
        }

        final parsedValue =
            value.runtimeType == int ? value : int.tryParse(value);

        if (parsedValue == null) return;

        rerunTimeout.value = parsedValue;
        await prefs.setInt("reconnect_timeout", parsedValue);

        break;
      default:
        throw UnsupportedError("Unknown setting");
    }

    notifyListeners();
  }

  List<Setting> getSettings() {
    return [scriptRepository, reloadInterval, rerunTimeout];
  }

  Setting getSetting(String key) {
    switch (key) {
      case "script_repository":
        return scriptRepository;
      case "reload_interval_millis":
        return reloadInterval;
      case "reconnect_timeout":
        return rerunTimeout;
      default:
        throw UnsupportedError("Unknown setting");
    }
  }
}
