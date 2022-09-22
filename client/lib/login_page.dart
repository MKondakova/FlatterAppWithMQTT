import 'package:client/registration_page.dart';
import 'package:client/user_main_page.dart';
import 'package:flutter/material.dart';

import 'connect_device_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String _title = 'MQTT App';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(
        body: LoginPageWidget(),
      ),
    );
  }
}

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({Key? key}) : super(key: key);

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
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
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(15)),
                child: const Text('Login'),
                onPressed: () {
                  print(nameController.text);
                  print(passwordController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DevicesList()),
                  );
                },
              )),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(15)),
                child: const Text('Create account'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
              )),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 15),
              child: TextButton(
                onPressed: () { Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ConnectDevicePage())); },
                child: const Text(
                  'Connect as device',
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ),
              ),
            ),
          )
        ]));
  }
}
