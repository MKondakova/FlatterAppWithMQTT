import 'package:client/login_page.dart';
import 'package:flutter/material.dart';

class ConnectDevicePage extends StatelessWidget {
  const ConnectDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Stack(children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Connect'),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  child: const Text(
                    'Connect as user',
                    style: TextStyle(color: Colors.deepPurpleAccent),
                  ),
                ),
              )
            ])));
  }
}
