import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
  //MQTTClientManager mqttClientManager = MQTTClientManager();
  final String pubTopic = "test/counter";

  final _formKey = GlobalKey<FormBuilderState>();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  final mockCredentials = {'login': 'user', 'password': 'password'};

  final snackBar = SnackBar(
    content: const Text('Incorrect Credentials!'),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      if (_formKey.currentState!.fields['login']?.value ==
              mockCredentials['login'] &&
          _formKey.currentState!.fields['password']?.value ==
              mockCredentials['password']) {
        Navigator.pushNamed(context, '/devices-list');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  var isLoginIconVisible = false;
  var isPasswordIconVisible = false;
  var isPasswordAgainIconVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
            children: <Widget>[
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
                          if (value == null || value.isEmpty) {
                            return 'Enter login';
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
                              value.length < 8) {
                            return 'Password must contains at least 8 symbols';
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
                        child: ElevatedButton(
                          onPressed: _validateForm,
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                        )),
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
