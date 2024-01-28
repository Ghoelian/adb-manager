import 'package:adb_manager/common/models/adb_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adbModel = Provider.of<AdbModel>(context, listen: false);

      adbModel.getDevices();
    });
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
            subtitle: Text(device.status),
          );
        },
      ),
    );
  }
}
