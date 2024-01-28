import 'package:adb_manager/common/models/scripts_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScriptsOverviewScreen extends StatelessWidget {
  const ScriptsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(6),
          child: ButtonRow(),
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        Expanded(
          child: Consumer<ScriptsModel>(
            builder: (context, scriptsModel, child) => ListView.builder(
                itemCount: scriptsModel.scripts.length,
                itemBuilder: (context, index) {
                  final script = scriptsModel.scripts[index];

                  return ListTile(
                    title: Text(script.name),
                    subtitle: Text(script.description),
                  );
                }),
          ),
        )
      ],
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [ReloadButton()],
    );
  }
}

class ReloadButton extends StatelessWidget {
  const ReloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Update scripts",
      child: Consumer<ScriptsModel>(
        builder: (context, scriptsModel, child) => IconButton(
          icon: const Icon(Icons.update),
          onPressed: () {
            scriptsModel.updateScripts();
          },
        ),
      ),
    );
  }
}
