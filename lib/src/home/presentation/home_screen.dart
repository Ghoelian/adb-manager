import 'dart:io';

import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    getDevices();
  }

  Future<void> getDevices() async {
    final shell = Shell();

    List<ProcessResult>? cmdOutput;

    // Hope including adb like this won't cause any issues
    if (Platform.isLinux) {
      cmdOutput = await shell.run('./include/adb devices');
    } else if (Platform.isWindows) {
      cmdOutput = await shell.run('./include/adb.exe devices');
    }

    print(cmdOutput?.outText);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
