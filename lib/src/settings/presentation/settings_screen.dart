import 'package:adb_manager/common/models/settings_model.dart';
import 'package:adb_manager/src/settings/presentation/edit_setting_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settingsModel, child) {
        final settings = settingsModel.getSettings();

        return SettingsList(settings: settings);
      },
    );
  }
}

class SettingsList extends StatelessWidget {
  final List<Setting> settings;

  const SettingsList({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: settings.length,
      itemBuilder: (BuildContext context, int index) {
        final setting = settings[index];

        return SettingTile(setting: setting);
      },
    );
  }
}

class SettingTile extends StatefulWidget {
  final Setting setting;

  const SettingTile({super.key, required this.setting});

  @override
  State<SettingTile> createState() => _SettingTileState();
}

class _SettingTileState extends State<SettingTile> {
  Future<void> _showEditDialogue(Setting setting) async {
    final settingsModel = Provider.of<SettingsModel>(context, listen: false);

    final newValue = await showDialog<String?>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return EditSettingDialogue(setting: setting);
        });

    if (newValue == null) return;

    settingsModel.updateSetting(setting.key, newValue);
  }

  void _restoreDefaultValue(Setting setting) {
    final settingsModel = Provider.of<SettingsModel>(context, listen: false);

    settingsModel.updateSetting(setting.key, null);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _showEditDialogue(widget.setting),
      title: Text(widget.setting.key),
      subtitle: Text(widget.setting.getValue().toString()),
      trailing: widget.setting.value != null
          ? Tooltip(
              message: "Restore default value",
              child: IconButton(
                  onPressed: () => _restoreDefaultValue(widget.setting),
                  icon: const Icon(Icons.settings_backup_restore)),
            )
          : null,
    );
  }
}
