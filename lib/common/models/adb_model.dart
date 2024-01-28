import 'dart:io';

import 'package:adb_manager/common/exceptions/adb_exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:process_run/process_run.dart';

enum AdbStatus { idle, runningTask, loading, errorred }

enum DeviceStatus { noPermissions, connected, unknown }

class Device {
  final String serialNumber;
  DateTime connectedAt;
  DeviceStatus status;

  Device(
      {required this.serialNumber,
      required this.status,
      required this.connectedAt});
}

class AdbModel extends ChangeNotifier {
  AdbStatus status = AdbStatus.idle;
  String? currentTask;

  List<Device> devices = List.empty(growable: true);

  AdbModel() {
    getDevices(0);
  }

  void runTask(String label, String task) {
    if (status != AdbStatus.idle) {
      throw DeviceBusyException("Busy running other task: $currentTask");
    }

    status = AdbStatus.runningTask;
    currentTask = label;

    notifyListeners();
  }

  Future<void> getDevices(int rerunTimeout) async {
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
      if (outLine == "") return;

      final [serial, status] = outLine.split("\t");

      DeviceStatus parsedStatus;

      if (status.startsWith("no permissions;")) {
        parsedStatus = DeviceStatus.noPermissions;
      } else if (status == "device") {
        parsedStatus = DeviceStatus.connected;
      } else {
        parsedStatus = DeviceStatus.unknown;
      }

      Device? existingDevice;

      for (final device in devices) {
        if (device.serialNumber == serial) {
          existingDevice = device;

          break;
        }
      }

      if (existingDevice != null) {
        if (existingDevice.status != parsedStatus &&
            DateTime.now()
                    .difference(existingDevice.connectedAt)
                    .inMilliseconds >
                rerunTimeout) {
          existingDevice.connectedAt = DateTime.now();
          // TODO: execute scripts
        }
        return;
      }

      devices.add(Device(
          serialNumber: serial,
          status: parsedStatus,
          connectedAt: DateTime.now()));
      // TODO: execute scripts
    });

    status = AdbStatus.idle;
    currentTask = null;

    notifyListeners();
  }
}
