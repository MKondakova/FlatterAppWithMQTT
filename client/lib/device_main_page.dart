import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models.dart';
import 'mqtt_client_manager.dart';

class DeviceMainPage extends StatefulWidget {
  const DeviceMainPage({super.key});

  @override
  State<DeviceMainPage> createState() => _DeviceMainPageState();
}

class _DeviceMainPageState extends State<DeviceMainPage> {
  late MQTTClientManager mqtt;

  @override
  void initState() {
    super.initState();
    mqtt = MQTTClientManager();
    mqtt.connect().whenComplete(() => mqtt.changeState("!"));
  }

  @override
  void dispose() {
    mqtt.disconnect();
    myController.dispose();
    super.dispose();
  }

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DeviceData deviceData = Provider.of<DeviceData>(context);
    mqtt.deviceData = deviceData;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: deviceData.data.id))
                      .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Uuid copied'),
                )); // -> show a notification
              }),
              tooltip: 'Share id',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<DeviceData>(builder: (context, data, child) {
                return TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: data.data.value,
                  ),
                );
              }),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  mqtt.changeState(myController.text);
                },
              )
            ],
          ),
        ));
  }
}
