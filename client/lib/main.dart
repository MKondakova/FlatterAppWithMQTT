import 'package:flutter/material.dart';

import 'add_device_page.dart';
import 'connect_device_page.dart';
import 'device_main_page.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'user_main_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/sign-up': (context) => const SignupPage(),
        '/devices-list': (context) => const DevicesList(),
        '/device-connect': (context) => const ConnectDevicePage(),
        '/device': (context) => const DeviceMainPage(),
        '/add-device': (context) => const AddDevicePage(),
      },
    ),
  );
}
