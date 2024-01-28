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
        setState(() {});
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
