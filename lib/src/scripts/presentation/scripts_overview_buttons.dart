import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/models/scripts_model.dart';

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
