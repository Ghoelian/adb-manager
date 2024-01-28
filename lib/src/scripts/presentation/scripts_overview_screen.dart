import 'package:adb_manager/common/models/scripts_model.dart';
import 'package:adb_manager/src/scripts/presentation/scripts_list.dart';
import 'package:adb_manager/src/scripts/presentation/scripts_overview_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScriptsOverviewScreen extends StatelessWidget {
  const ScriptsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(6),
          child: ButtonRow(),
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
        Expanded(
          child: ScriptsList(),
        )
      ],
    );
  }
}
