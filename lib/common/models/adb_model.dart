import 'package:adb_manager/common/exceptions/adb_exceptions.dart';
import 'package:flutter/cupertino.dart';

enum AdbStatus { idle, runningTask, loading, errorred }

class AdbModel extends ChangeNotifier {
  AdbStatus status = AdbStatus.idle;
  String? currentTask;

  void runTask(String label, String task) {
    if (status != AdbStatus.idle) {
      throw DeviceBusyException("Busy running other task: $currentTask");
    }

    status = AdbStatus.runningTask;
    currentTask = label;

    notifyListeners();
  }
}
