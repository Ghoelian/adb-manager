import 'dart:io';

import 'package:adb_manager/common/exceptions/adb_exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:process_run/process_run.dart';

enum AdbStatus { idle, runningTask, loading, errorred }

class Device {
  final String serialNumber;
  String status;

  Device({required this.serialNumber, required this.status});
}

class AdbModel extends ChangeNotifier {
  AdbStatus status = AdbStatus.idle;
  String? currentTask;

  List<Device> devices = List.empty(growable: true);

  void runTask(String label, String task) {
    if (status != AdbStatus.idle) {
      throw DeviceBusyException("Busy running other task: $currentTask");
    }

    status = AdbStatus.runningTask;
    currentTask = label;

    notifyListeners();
  }

  Future<void> getDevices() async {
    status = AdbStatus.runningTask;
    currentTask = "getting devices";

    notifyListeners();

    final shell = Shell();

    List<ProcessResult>? cmdOutput;

    // Hope including adb like this won't cause any issues
    if (Platform.isLinux) {
      cmdOutput = await shell.run('./include/adb devices');
    } else if (Platform.isWindows) {
      cmdOutput = await shell.run('./include/adb.exe devices');
    }

    devices = List.empty(growable: true);

    cmdOutput?.outLines.skip(1).forEach((outLine) {
      if (outLine == "") return;

      final [serial, status] = outLine.split("\t");

      devices.add(Device(serialNumber: serial, status: status));
    });

    status = AdbStatus.idle;
    currentTask = null;

    notifyListeners();
  }
}
