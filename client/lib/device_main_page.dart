import 'package:flutter/material.dart';

class DeviceMainPage extends StatelessWidget {
  const DeviceMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () =>
                  { print("Id: c4fbed52-d362-4185-ba6c-a05af13c4906") },
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
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Value',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Switch(
                      value: false,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                      }),
                  const Text("Enabled") //TODO add state and change for disabled
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {},
              )
            ],
          ),
        ));
  }
}
