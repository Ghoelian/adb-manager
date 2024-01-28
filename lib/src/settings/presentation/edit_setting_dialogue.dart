import 'package:adb_manager/common/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditSettingDialogue extends StatefulWidget {
  final Setting setting;

  const EditSettingDialogue({super.key, required this.setting});

  @override
  State<EditSettingDialogue> createState() => _EditSettingDialogueState();
}

class _EditSettingDialogueState extends State<EditSettingDialogue> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _textController.text = widget.setting.getValue().toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.setting.key),
      content: SingleChildScrollView(
          child: TextField(
        controller: _textController,
      )),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              context.pop(_textController.value.text);
            },
            child: const Text("Save"))
      ],
    );
  }
}
