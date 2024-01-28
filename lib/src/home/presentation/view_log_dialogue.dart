import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:any_syntax_highlighter/themes/any_syntax_highlighter_theme_collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewLogDialogue extends StatefulWidget {
  final String log;

  const ViewLogDialogue({super.key, required this.log});

  @override
  State<ViewLogDialogue> createState() => _ViewLogDialogueState();
}

class _ViewLogDialogueState extends State<ViewLogDialogue> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Script output"),
      content: SingleChildScrollView(
        child: AnySyntaxHighlighter(
          widget.log,
          theme: AnySyntaxHighlighterThemeCollection.githubWebTheme(),
          lineNumbers: true,
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
