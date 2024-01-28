import 'package:flutter/cupertino.dart';

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

  void updateSetting(String key, dynamic value) {
    switch (key) {
      case "script_repository":
        if (value == null) {
          scriptRepository.value = null;
          notifyListeners();
          return;
        }

        final parsedValue = Uri.tryParse(value);

        if (parsedValue == null) return;

        scriptRepository.value = parsedValue;
        break;
      case "reload_interval_millis":
        if (value == null) {
          reloadInterval.value = null;
          notifyListeners();
          return;
        }

        final parsedValue =
            value.runtimeType == int ? value : int.tryParse(value);

        if (parsedValue == null) return;

        reloadInterval.value = parsedValue;
        break;
      case "reconnect_timeout":
        if (value == null) {
          rerunTimeout.value = null;
          notifyListeners();
          return;
        }

        final parsedValue =
            value.runtimeType == int ? value : int.tryParse(value);

        if (parsedValue == null) return;

        rerunTimeout.value = parsedValue;
      default:
        throw UnsupportedError("Unknown setting");
    }

    notifyListeners();
  }

  List<Setting> getSettings() {
    return [scriptRepository, reloadInterval, rerunTimeout];
  }
}
