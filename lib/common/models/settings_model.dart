import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingKeys {
  static const String scriptRepository = "script_repository";
  static const String reloadInterval = "reload_interval_millis";
  static const String rerunTimeout = "reconnect_timeout";
}

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
      key: SettingKeys.scriptRepository,
      defaultValue: "https://github.com/Ghoelian/adb-manager-scripts.git");
  final reloadInterval =
      Setting(key: SettingKeys.reloadInterval, defaultValue: 5 * 1000);
  final rerunTimeout =
      Setting(key: SettingKeys.rerunTimeout, defaultValue: 10 * 1000);

  bool loading = true;

  SettingsModel() {
    populateSettings();
  }

  Future<void> populateSettings() async {
    loading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    final repoValue = prefs.getString(SettingKeys.scriptRepository);
    final reloadValue = prefs.getInt(SettingKeys.reloadInterval);
    final rerunValue = prefs.getInt(SettingKeys.rerunTimeout);

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
      case SettingKeys.scriptRepository:
        if (value == null) {
          scriptRepository.value = null;
          notifyListeners();

          await prefs.remove(SettingKeys.scriptRepository);
          return;
        }

        final parsedValue = Uri.tryParse(value);

        if (parsedValue == null) return;

        scriptRepository.value = parsedValue;
        await prefs.setString(
            SettingKeys.scriptRepository, parsedValue.toString());

        break;
      case SettingKeys.reloadInterval:
        if (value == null) {
          reloadInterval.value = null;
          notifyListeners();

          await prefs.remove(SettingKeys.reloadInterval);
          return;
        }

        final parsedValue =
            value.runtimeType == int ? value : int.tryParse(value);

        if (parsedValue == null) return;

        reloadInterval.value = parsedValue;
        await prefs.setInt(SettingKeys.reloadInterval, parsedValue);

        break;
      case SettingKeys.rerunTimeout:
        if (value == null) {
          rerunTimeout.value = null;
          notifyListeners();

          await prefs.remove(SettingKeys.rerunTimeout);
          return;
        }

        final parsedValue =
            value.runtimeType == int ? value : int.tryParse(value);

        if (parsedValue == null) return;

        rerunTimeout.value = parsedValue;
        await prefs.setInt(SettingKeys.rerunTimeout, parsedValue);

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
      case SettingKeys.scriptRepository:
        return scriptRepository;
      case SettingKeys.reloadInterval:
        return reloadInterval;
      case SettingKeys.rerunTimeout:
        return rerunTimeout;
      default:
        throw UnsupportedError("Unknown setting");
    }
  }
}
