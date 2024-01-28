import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // TODO: temporary, should make a central settings store and dynamically create these tiles at some point
      children: const [
        Tooltip(
          message: "Repository where scripts will be pulled from.",
          child: ListTile(
            title: Text("Script repository"),
            subtitle:
                Text("https://github.com/Ghoelian/adb-manager-scripts.git"),
          ),
        ),
        Tooltip(
          message: "How often the program scans for new devices.",
          child: ListTile(
            title: Text("Scan interval"),
            subtitle: Text("10 seconds"),
          ),
        ),
        Tooltip(
          message:
              "If a device gets disconnected and re-connected within this time, scripts will not be re-run.",
          child: ListTile(
              title: Text("Script re-run timeout"),
              subtitle: Text("10 seconds")),
        )
      ],
    );
  }
}
