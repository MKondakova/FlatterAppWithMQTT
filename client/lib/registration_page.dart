import 'package:client/login_page.dart';
import 'package:client/user_main_page.dart';
import 'package:flutter/material.dart';

import 'connect_device_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static const String _title = 'MQTT App';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(
        body: SignupPageWidget(),
      ),
    );
  }
}

class SignupPageWidget extends StatefulWidget {
  const SignupPageWidget({Key? key}) : super(key: key);

  @override
  State<SignupPageWidget> createState() => _SignupPageWidgetState();
}

class _SignupPageWidgetState extends State<SignupPageWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              padding:
                  const EdgeInsets.symmetric(vertical: 120.0, horizontal: 30.0),
              child: const Text(
                'Welcome!',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Login',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password again',
              ),
            ),
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ElevatedButton(
                child: const Text('Sign up'),
                onPressed: () {
                  print(nameController.text);
                  print(passwordController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DevicesList()),
                  );
                },
              )),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              )),
          Container(
            alignment: Alignment.bottomCenter,
            padding:
                const EdgeInsets.symmetric(vertical: 120.0, horizontal: 30.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ConnectDevicePage()));
              },
              child: const Text(
                'Connect as device',
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),
            ),
          )
        ]));
  }
}
