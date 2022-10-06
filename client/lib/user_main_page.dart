import 'package:flutter/material.dart';

import 'models.dart';

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
              onPressed: () => { print("updated") },
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
            size: 44.0,
            semanticLabel: 'Add Device',
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              Device item = _devices[index];
              return Card(
                  color: const Color(0xd2f7ebff),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: Text(item.name),
                    trailing: Text(
                      item.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          color:
                          item.isEnabled ? Colors.black : Colors.black12),
                    ),
                  ));
            },
          ),)
    );
  }
}