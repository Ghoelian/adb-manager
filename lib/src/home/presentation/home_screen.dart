import 'dart:async';

import 'package:adb_manager/common/models/adb_model.dart';
import 'package:adb_manager/common/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Timer timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        final adb = Provider.of<AdbModel>(context, listen: false);
        final settingsModel =
            Provider.of<SettingsModel>(context, listen: false);

        adb.getDevices(
            settingsModel.getSetting(SettingKeys.rerunTimeout).getValue());
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(6),
          child: ButtonRow(),
        ),
        Expanded(
          child: DeviceList(),
        )
      ],
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdbModel>(
      builder: (context, adb, child) => Row(
        children: [
          ReloadButton(adb: adb),
          ClearDisconnectedButton(
            adb: adb,
          )
        ],
      ),
    );
  }
}

class ReloadButton extends StatelessWidget {
  final AdbModel adb;

  const ReloadButton({super.key, required this.adb});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Reload devices",
      child: Consumer<SettingsModel>(
        builder: (context, settingsModel, child) => IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            adb.getDevices(
                settingsModel.getSetting(SettingKeys.rerunTimeout).getValue());
          },
        ),
      ),
    );
  }
}

class ClearDisconnectedButton extends StatelessWidget {
  final AdbModel adb;

  const ClearDisconnectedButton({super.key, required this.adb});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Clear disconnected devices",
      child: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          adb.clearDisconnected();
        },
      ),
    );
  }
}

class DeviceList extends StatelessWidget {
  const DeviceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdbModel>(
      builder: (context, adb, child) => ListView.builder(
        itemCount: adb.devices.length,
        itemBuilder: (BuildContext context, int index) {
          final device = adb.devices[index];

          return ListTile(
            title: Text(device.serialNumber),
            subtitle: Text(
                "${device.status} – ${GetTimeAgo.parse(device.connectedAt)}"),
          );
        },
      ),
    );
  }
}
