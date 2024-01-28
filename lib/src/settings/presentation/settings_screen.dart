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
      children: const [
        Tooltip(
          message: "How often the program scans for new devices.",
          child: ListTile(
          title: Text("Scan interval"),
          subtitle: Text("10 seconds"),
        ),),
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
