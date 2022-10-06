import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models.dart';
import 'mqtt_client_manager.dart';

class DevicesList extends StatefulWidget {
  const DevicesList({super.key});

  @override
  State<StatefulWidget> createState() => _DevicesListState();
}

class _DevicesListState extends State<DevicesList> {
  late MQTTClientManager mqtt;

  @override
  void initState() {
    super.initState();
    mqtt = MQTTClientManager();
    mqtt.connect().whenComplete(() => mqtt.updateDevices());
  }

  @override
  void dispose() {
    mqtt.disconnect();
    super.dispose();
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, String uuid, String oldVal) async {
    String value = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter a value'),
            content: TextField(
              decoration: InputDecoration(labelText: oldVal),
              onChanged: (v) {
                setState(() {
                  value = v;
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  mqtt.giveAnOrder(uuid, value);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);
    mqtt.userData = userData;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Devices:"),
          actions: [
            IconButton(
              icon: const Icon(Icons.restart_alt_rounded),
              onPressed: () => () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Processing Data'),
                ));
                mqtt.updateDevices();
              },
              tooltip: 'Saved Suggestions',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add-device');
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            semanticLabel: 'Add Device',
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Consumer<UserData>(builder: (context, data, child) {
            return ListView.builder(
              itemCount: data.devices.length,
              itemBuilder: (context, index) {
                Device item = data.devices[index];
                return Card(
                    color: const Color(0xd2f7ebff),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      title: Text(item.name),
                      trailing: TextButton(
                        onPressed: () {
                          _displayTextInputDialog(context, item.id, item.value);
                        },
                        child: Text(item.value.isNotEmpty ? item.value[0] : '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 24, color: Colors.black)),
                      ),
                    ));
              },
            );
          }),
        ));
  }
}
