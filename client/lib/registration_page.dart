import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  static const String _title = 'MQTT App';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: const SignupPageWidget(),
    );
  }
}

class SignupPageWidget extends StatefulWidget {
  const SignupPageWidget({Key? key}) : super(key: key);

  @override
  State<SignupPageWidget> createState() => _SignupPageWidgetState();
}

class _SignupPageWidgetState extends State<SignupPageWidget> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();

  final snackBar = SnackBar(
    content: const Text('The passwords don\'t match!'),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  var isLoginIconVisible = false;
  var isPasswordIconVisible = false;
  var isPasswordAgainIconVisible = false;

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      if (_formKey.currentState?.fields['password']?.value !=
          _formKey.currentState?.fields['passwordAgain']?.value) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        Navigator.pushNamed(context, '/devices-list');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10),
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
                      _formKey.currentState!.validate();
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
                  margin: const EdgeInsets.all(10),
                  child: FormBuilderTextField(
                    name: 'password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 8) {
                        return 'Password must contains at least 8 symbols';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    onChanged: (word) {
                      setState(() {
                        isPasswordIconVisible = (word ?? '').isNotEmpty;
                      });
                      _formKey.currentState!.validate();
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
                  margin: const EdgeInsets.all(10),
                  child: FormBuilderTextField(
                    name: 'passwordAgain',
                    obscureText: true,
                    controller: _passwordAgainController,
                    onChanged: (word) {
                      setState(() {
                        isPasswordAgainIconVisible = (word ?? '').isNotEmpty;
                      });
                      _formKey.currentState!.validate();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 8) {
                        return 'Password must contains at least 8 symbols';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password again',
                      suffixIcon: isPasswordAgainIconVisible
                          ? IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: _passwordAgainController.clear,
                            )
                          : null,
                    ),
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      onPressed: _validateForm,
                    )),
              ],
            ),
          )
        ]));
  }
}
