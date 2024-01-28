import 'package:adb_manager/src/scripts/presentation/view_script_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/models/scripts_model.dart';

class ScriptsList extends StatefulWidget {
  const ScriptsList({super.key});

  @override
  State<ScriptsList> createState() => _ScriptsListState();
}

class _ScriptsListState extends State<ScriptsList> {
  Future<void> _viewScript(Script script) async {
    return await showDialog(
        context: context,
        builder: (context) => ViewScriptDialogue(script: script));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScriptsModel>(
      builder: (context, scriptsModel, child) => ListView.builder(
          itemCount: scriptsModel.scripts.length,
          itemBuilder: (context, index) {
            final script = scriptsModel.scripts[index];

            return ListTile(
              title: Text(script.name),
              subtitle: Text(script.description),
              onTap: () => _viewScript(script),
            );
          }),
    );
  }
}
