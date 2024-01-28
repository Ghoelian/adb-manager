import 'package:adb_manager/common/models/adb_model.dart';
import 'package:adb_manager/common/widgets/adb_manager_nav_rail.dart';
import 'package:adb_manager/common/widgets/adb_manager_scaffold.dart';
import 'package:adb_manager/src/home/presentation/home_screen.dart';
import 'package:adb_manager/src/scripts/presentation/scripts_overview_screen.dart';
import 'package:adb_manager/src/settings/presentation/settings_screen.dart';
import 'package:adb_manager/src/status_bar/presentation/status_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AdbManager());
}

class AdbManager extends StatelessWidget {
  const AdbManager({super.key});

  static final _router = GoRouter(routes: [
    ShellRoute(
        routes: [
          GoRoute(path: "/", builder: (context, state) => const HomeScreen()),
          GoRoute(
              path: "/scripts",
              builder: (context, state) => const ScriptsOverviewScreen()),
          GoRoute(
              path: "/settings",
              builder: (context, state) => const SettingsScreen()),
        ],
        builder: (context, state, child) =>
            AdbManagerScaffold(state: state, child: child))
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'ADB manager',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark),
          useMaterial3: true),
    );
  }
}
