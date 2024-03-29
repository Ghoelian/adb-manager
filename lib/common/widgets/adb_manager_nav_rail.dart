import 'package:adb_manager/common/models/adb_model.dart';
import 'package:adb_manager/common/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdbManagerNavRail extends StatefulWidget {
  final GoRouterState state;

  const AdbManagerNavRail({super.key, required this.state});

  @override
  State<AdbManagerNavRail> createState() => _AdbManagerNavRailState();
}

class _AdbManagerNavRailState extends State<AdbManagerNavRail> {
  int _selectedIndex = 0;

  void onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go("/");
        break;
      case 1:
        context.go("/scripts");
        break;
      case 2:
        context.go("/settings");
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
        labelType: NavigationRailLabelType.all,
        onDestinationSelected: onDestinationSelected,
        destinations: const [
          NavigationRailDestination(
              icon: Icon(Icons.usb_outlined),
              selectedIcon: Icon(Icons.usb),
              label: Text('Devices')),
          NavigationRailDestination(
              icon: Icon(Icons.description_outlined),
              selectedIcon: Icon(Icons.description),
              label: Text('Scripts')),
          NavigationRailDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: Text('Settings'))
        ],
        selectedIndex: _selectedIndex);
  }
}
