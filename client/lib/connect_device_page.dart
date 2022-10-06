import 'package:client/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mqtt_client_manager.dart';

class ConnectDevicePage extends StatefulWidget {
  const ConnectDevicePage({super.key});

  @override
  State<ConnectDevicePage> createState() => _ConnectDevicePageState();
}

class _ConnectDevicePageState extends State<ConnectDevicePage> {
  late MQTTClientManager mqtt;

  @override
  void initState() {
    super.initState();
    mqtt = MQTTClientManager();
    mqtt.connect();
  }

  @override
  void dispose() {
    mqtt.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeviceData deviceData = Provider.of<DeviceData>(context);
    mqtt.deviceData = deviceData;
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Stack(children: [
              Center(
                child: Consumer<DeviceData>(builder: (context, data, child) {
                  if (data.isLoggedIn == 2) {
                    data.isLoggedIn = 0;
                    Future.microtask(() =>
                        Navigator.pushReplacementNamed(context, '/device'));
                  }
                  if (data.isLoggedIn == 3) {
                    Future.microtask(() => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Try again'),
                        )));
                    data.isLoggedIn = 0;
                  }
                  return ElevatedButton(
                    onPressed: () {
                      data.isLoggedIn == 0 ? mqtt.registerDevice() : null;
                    },
                    child: Text(data.isLoggedIn == 0 ? 'Connect' : 'Wait...'),
                  );
                }),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Connect as user'),
                ),
              )
            ])));
  }
}
