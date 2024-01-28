import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:process_run/process_run.dart';

class Script {
  final String name;
  final String description;
  final String path;

  Script({required this.name, required this.description, required this.path});
}

class ScriptsModel extends ChangeNotifier {
  bool loading = false;
  List<Script> scripts = List.empty(growable: true);

  ScriptsModel() {
    Directory("./include/scripts").exists().then((exists) {
      if (!exists) {
        updateScripts();

        return;
      }

      parseScripts();
    });
  }

  /// TODO: only do this after the user has explicitly given permission to download stuff.
  ///   RCE vulnerabilities and shit
  Future<void> updateScripts({int depth = 0}) async {
    loading = true;
    notifyListeners();

    final shell = Shell();

    if (await Directory("./include/scripts").exists()) {
      await shell.cd("./include/scripts").run("""
            git fetch --all
            git reset --hard origin/master
          """);
    } else {
      final outLines = await shell.cd("./include").run(
          "git clone https://github.com/Ghoelian/adb-manager-scripts ./scripts");

      if (!await Directory("./include/scripts").exists()) {
        throw Exception("git clone failed: \n${outLines.outText}");
      }
    }

    parseScripts(depth: depth);

    notifyListeners();
  }

  Future<void> parseScripts({int depth = 0}) async {
    try {
      final metadataFile = File("./include/scripts/metadata.json");

      final metadataJson = jsonDecode(await metadataFile.readAsString());

      scripts = List.empty(growable: true);

      for (final scriptJson in metadataJson) {
        scripts.add(Script(
            name: scriptJson["name"],
            description: scriptJson["description"],
            path: scriptJson["path"]));
      }

      notifyListeners();
    } on IOException catch (e) {
      if (depth > 0) {
        // still couldn't find metadata, bail and reset repo to default
        return;
      }

      // TODO: show error message, ask user if they want to update
      updateScripts(depth: depth + 1);
    }
  }
}
