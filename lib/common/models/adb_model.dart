import 'dart:io';

import 'package:adb_manager/common/exceptions/adb_exceptions.dart';
import 'package:adb_manager/common/models/scripts_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:process_run/process_run.dart';

enum AdbStatus { idle, runningTask, loading, errorred }

enum DeviceStatus { noPermissions, connected, unknown, disconnected }

class ScriptLog {
  final Script script;
  final String log;
  final DateTime date;

  ScriptLog({required this.script, required this.log, required this.date});
}

class Device {
  final String serialNumber;
  DateTime connectedAt;
  DeviceStatus status;
  String? model;

  List<ScriptLog> scriptLog = List.empty(growable: true);

  Device(
      {required this.serialNumber,
      required this.status,
      required this.connectedAt,
      this.model});

  String statusToString() {
    switch (status) {
      case DeviceStatus.connected:
        return 'Connected';
      case DeviceStatus.disconnected:
        return 'Disconnected';
      case DeviceStatus.noPermissions:
        return 'ADB not allowed';
      case DeviceStatus.unknown:
        return 'Unknown';
    }
  }
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

  Device? _findExistingDevice(String serial, List<Device> oldDevices) {
    Device? existingDevice;

    for (final device in oldDevices) {
      if (device.serialNumber == serial) {
        existingDevice = device;
        oldDevices.remove(device);

        break;
      }
    }

    return existingDevice;
  }

  DeviceStatus parseStatus(String status) {
    DeviceStatus parsedStatus;

    if (status.startsWith("no permissions;")) {
      parsedStatus = DeviceStatus.noPermissions;
    } else if (status == "device") {
      parsedStatus = DeviceStatus.connected;
    } else {
      parsedStatus = DeviceStatus.unknown;
    }

    return parsedStatus;
  }

  Future<void> getDeviceModel(Device device) async {
    final shell = Shell();

    final outLines = await shell.run(
        "adb -s \"${device.serialNumber}\" shell getprop ro.product.model");

    device.model = outLines.outText;

    notifyListeners();
  }

  Future<void> runScripts(List<Script> scripts, Device device) async {
    final shell = Shell();

    for (final script in scripts) {
      final outLines = await shell
          .cd("./include/scripts")
          .run("${script.path} ${device.serialNumber}");

      device.scriptLog.add(ScriptLog(
          script: script, log: outLines.outText, date: DateTime.now()));
    }
  }

  void _parseOutLine(String outLine, List<Device> oldDevices,
      List<Device> newDevices, int rerunTimeout, List<Script> scripts) {
    if (outLine == "") return;

    final [serial, status] = outLine.split("\t");

    final existingDevice = _findExistingDevice(serial, oldDevices);

    DeviceStatus parsedStatus = parseStatus(status);

    if (existingDevice != null) {
      if (existingDevice.status != parsedStatus &&
          DateTime.now().difference(existingDevice.connectedAt).inMilliseconds >
              rerunTimeout) {
        existingDevice.status = parsedStatus;
        existingDevice.connectedAt = DateTime.now();

        if (existingDevice.status == DeviceStatus.connected) {
          getDeviceModel(existingDevice);
          runScripts(scripts, existingDevice);
        }
      }

      newDevices.add(existingDevice);

      notifyListeners();

      return;
    }

    final newDevice = Device(
        serialNumber: serial,
        status: parsedStatus,
        connectedAt: DateTime.now());

    newDevices.add(newDevice);

    if (newDevice.status == DeviceStatus.connected) {
      getDeviceModel(newDevice);
      runScripts(scripts, newDevice);
    }
  }

  Future<void> getDevices(int rerunTimeout, List<Script> scripts) async {
    final oldDevices = [...devices];

    List<Device> newDevices = List.empty(growable: true);

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

    cmdOutput?.outLines.skip(1).forEach((outLine) {
      _parseOutLine(outLine, oldDevices, newDevices, rerunTimeout, scripts);
    });

    for (final device in oldDevices) {
      device.status = DeviceStatus.disconnected;
      newDevices.add(device);
    }

    devices = newDevices;

    status = AdbStatus.idle;
    currentTask = null;

    notifyListeners();
  }

  void clearDisconnected() {
    devices.removeWhere((device) => device.status == DeviceStatus.disconnected);

    notifyListeners();
  }
}
