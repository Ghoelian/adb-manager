import 'package:adb_manager/common/models/adb_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusBarWidget extends StatelessWidget {
  final List<Widget> children;

  const StatusBarWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      ),
    );
  }
}
