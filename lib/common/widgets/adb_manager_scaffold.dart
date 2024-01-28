import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../src/status_bar/presentation/status_bar_widget.dart';
import '../models/adb_model.dart';
import 'adb_manager_nav_rail.dart';

const statusColorMap = {
  AdbStatus.idle: Colors.green,
  AdbStatus.loading: Colors.blue,
  AdbStatus.runningTask: Colors.yellow,
  AdbStatus.errorred: Colors.red
};

const statusTextMap = {
  AdbStatus.idle: "Idle",
  AdbStatus.loading: "Loading",
  AdbStatus.runningTask: "Running task",
  AdbStatus.errorred: "Error"
};

class AdbManagerScaffold extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const AdbManagerScaffold(
      {super.key, required this.child, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => AdbModel(),
        child: MainRow(
          state: state,
          child: child,
        ),
      ),
    );
  }
}

/// Row containing the nav rail and main content.
class MainRow extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const MainRow({super.key, required this.child, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AdbManagerNavRail(state: state),
        const VerticalDivider(
          thickness: 1,
          width: 1,
        ),
        Expanded(
            child: SecondaryColumn(
          child: child,
        ))
      ],
    );
  }
}

/// Column containing main content and status bar
class SecondaryColumn extends StatelessWidget {
  final Widget child;

  const SecondaryColumn({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        const Divider(
          thickness: 1,
          height: 1,
        ),
        const StatusBarWidget(children: [StatusItem()])
      ],
    );
  }
}

class StatusItem extends StatelessWidget {
  const StatusItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdbModel>(
      builder: (context, adb, child) => RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "${statusTextMap[adb.status]!} "),
            WidgetSpan(
              child: Icon(
                Icons.circle,
                color: statusColorMap[adb.status],
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
