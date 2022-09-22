import 'package:flutter/material.dart';

class DeviceMainPage extends StatelessWidget {
  const DeviceMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Id: c4fbed52-d362-4185-ba6c-a05af13c4906'),
        ),
        body: Center(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Value',
                ),
              ),
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
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {},
              )
            ],
          ),
        ));
  }
}
