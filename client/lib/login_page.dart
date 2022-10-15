import 'package:client/mqtt_client_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'models.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String _title = 'MQTT App';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: const LoginPageWidget(),
    );
  }
}

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({Key? key}) : super(key: key);

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  final snackBar = SnackBar(
    content: const Text('Incorrect Credentials!'),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  late MQTTClientManager mqtt;

  @override
  void initState() {
    super.initState();
    mqtt = MQTTClientManager();
    mqtt.connect();
  }

  @override
  void dispose() {
    mqtt.disconnect();
    super.dispose();
  }

  var isLoginIconVisible = false;
  var isPasswordIconVisible = false;
  var isPasswordAgainIconVisible = false;

  Future<void> _validateForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Processing Data'),
      ));

      mqtt.loginUser(_formKey.currentState!.fields['login']!.value,
          _formKey.currentState!.fields['password']!.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);
    mqtt.userData = userData;
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              margin:
                  const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
              child: const Text(
                'Welcome!',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 34),
              )),
          FormBuilder(
              key: _formKey,
              child: Column(children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(6),
                  child: FormBuilderTextField(
                    name: 'login',
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length > 8 ||
                          value.length < 2) {
                        return 'Enter login and 2 <= length <= 8 symbols';
                      }
                      return null;
                    },
                    controller: _loginController,
                    onChanged: (word) {
                      setState(() {
                        isLoginIconVisible = (word ?? '').isNotEmpty;
                      });
                      _formKey.currentState!.fields['login']?.validate();
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Login',
                      suffixIcon: isLoginIconVisible
                          ? IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: _loginController.clear,
                            )
                          : null,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(6),
                  child: FormBuilderTextField(
                    name: 'password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length > 8 ||
                          value.length < 2) {
                        return 'Password must contains 2 <= length <= 8 symbols';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    onChanged: (word) {
                      setState(() {
                        isPasswordIconVisible = (word ?? '').isNotEmpty;
                      });
                      _formKey.currentState!.fields['password']?.validate();
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: isPasswordIconVisible
                          ? IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: _passwordController.clear,
                            )
                          : null,
                    ),
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.all(6),
                    child: Consumer<UserData>(builder: (context, data, child) {
                      if (data.isLoggedIn == 2) {
                        data.isLoggedIn = 0;
                        Future.microtask(() =>
                            Navigator.pushNamed(context, '/devices-list'));
                      }
                      if (data.isLoggedIn == 3) {
                        Future.microtask(() => ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar));
                        data.isLoggedIn = 0;
                      }
                      return ElevatedButton(
                        onPressed: data.isLoggedIn == 0 ? _validateForm : null,
                        child: Text(
                          data.isLoggedIn == 0 ? 'Log In' : 'Wait...',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      );
                    })),
                Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.all(6),
                    child: OutlinedButton(
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign-up');
                      },
                    )),
              ])),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 15),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/device-connect');
              },
              child: const Text('Connect as device'),
            ),
          ),
        ]));
  }
}
