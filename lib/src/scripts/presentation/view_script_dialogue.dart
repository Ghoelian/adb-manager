import 'dart:io';

import 'package:adb_manager/common/models/scripts_model.dart';
import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:any_syntax_highlighter/themes/any_syntax_highlighter_theme.dart';
import 'package:any_syntax_highlighter/themes/any_syntax_highlighter_theme_collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewScriptDialogue extends StatefulWidget {
  final Script script;

  const ViewScriptDialogue({super.key, required this.script});

  @override
  State<ViewScriptDialogue> createState() => _ViewScriptDialogueState();
}

class _ViewScriptDialogueState extends State<ViewScriptDialogue> {
  String? scriptText;

  @override
  void initState() {
    super.initState();

    getScriptText(widget.script);
  }

  Future<void> getScriptText(Script script) async {
    final file = File("./include/scripts/${script.path}");
    final text = await file.readAsString();

    setState(() {
      scriptText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.script.name),
      content: SingleChildScrollView(
        child: scriptText == null
            ? const CircularProgressIndicator()
            : AnySyntaxHighlighter(
                scriptText!,
                lineNumbers: true,
                theme: AnySyntaxHighlighterThemeCollection.githubWebTheme(),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text("Close"),
        )
      ],
    );
  }
}
