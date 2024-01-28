import 'package:adb_manager/src/home/presentation/view_log_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:go_router/go_router.dart';

import '../../../common/models/adb_model.dart';

class DeviceLogDialogue extends StatefulWidget {
  final Device device;

  const DeviceLogDialogue({super.key, required this.device});

  @override
  State<DeviceLogDialogue> createState() => _DeviceLogDialogueState();
}

class _DeviceLogDialogueState extends State<DeviceLogDialogue> {
  Future<void> _viewLog(String log) async {
    return await showDialog(
        context: context, builder: (context) => ViewLogDialogue(log: log));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.device.model ?? widget.device.serialNumber),
      content: SingleChildScrollView(
        child: SizedBox(
          height: 100,
          width: 100,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.device.scriptLog.length,
              itemBuilder: (context, index) {
                final log = widget.device.scriptLog[index];

                return ListTile(
                  onTap: () => _viewLog(log.log),
                  title: Text(log.script.name),
                  subtitle: Text(GetTimeAgo.parse(log.date)),
                );
              }),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text("Close"))
      ],
    );
  }
}
