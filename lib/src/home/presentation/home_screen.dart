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
        Divider(
          height: 1,
          thickness: 1,
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

class DeviceList extends StatefulWidget {
  const DeviceList({super.key});

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  Future<void> _showDeviceLog(Device device) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => DeviceLogDialogue(device: device));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdbModel>(
      builder: (context, adb, child) => ListView.builder(
        itemCount: adb.devices.length,
        itemBuilder: (BuildContext context, int index) {
          final device = adb.devices[index];
          final lastOutput = device.scriptLog.lastOrNull;

          return ListTile(
            onTap: () => _showDeviceLog(device),
            title: Text(device.model ?? device.serialNumber),
            subtitle: Text(lastOutput != null
                ? "${device.statusToString()} – ${GetTimeAgo.parse(device.connectedAt)} – last result: ${lastOutput.log}"
                : "${device.statusToString()} – ${GetTimeAgo.parse(device.connectedAt)}"),
          );
        },
      ),
    );
  }
}
