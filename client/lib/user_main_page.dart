import 'package:flutter/material.dart';

class DevicesList extends StatefulWidget {
  const DevicesList({super.key});

  @override
  State<StatefulWidget> createState() => _DevicesListState();
}

class _DevicesListState extends State<DevicesList> {
  final _devices = <Device>[
    Device("first", "uewurfwu-232-2334", "6", true),
    Device("second", "jsdahfkjhsdfjkahsdjkfhals", "7", false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Devices:"),
          actions: [
            IconButton(
              icon: const Icon(Icons.restart_alt_rounded),
              onPressed: () => {print("updated")},
              tooltip: 'Saved Suggestions',
            ),
          ],
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _devices.length,
            itemBuilder: (BuildContext context, int index) {
              var currDevice = _devices[index];
              return Card(
                  color: const Color(0xd2f7ebff),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: Text(currDevice.name),
                    trailing: Text(
                      currDevice.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                          color: currDevice.isEnabled
                              ? Colors.black
                              : Colors.black12),
                    ),
                  ));
            }));
  }
}

class Device {
  String name;
  String id;
  String value;
  bool isEnabled;

  Device(this.name, this.id, this.value, this.isEnabled);
}
