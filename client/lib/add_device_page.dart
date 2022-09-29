import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddDevicePage extends StatelessWidget {
  const AddDevicePage({super.key});

  static const String _title = 'MQTT App';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: const AddDevicePageWidget(),
    );
  }
}

class AddDevicePageWidget extends StatefulWidget {
  const AddDevicePageWidget({Key? key}) : super(key: key);

  @override
  State<AddDevicePageWidget> createState() => _AddDevicePageWidget();
}

class _AddDevicePageWidget extends State<AddDevicePageWidget> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _nameController = TextEditingController();
  final _idController = TextEditingController();

  var isNameIconVisible = false;
  var isIdIconVisible = false;

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      Navigator.pop(context);
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
                  const EdgeInsets.symmetric(vertical: 80.0, horizontal: 10.0),
              child: const Text(
                'Create new Device:',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 28),
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
                        return 'Enter device Name';
                      }
                      return null;
                    },
                    controller: _nameController,
                    onChanged: (word) {
                      setState(() {
                        isNameIconVisible = (word ?? '').isNotEmpty;
                      });
                      _formKey.currentState!.fields['login']?.validate();
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Device Name',
                      suffixIcon: isNameIconVisible
                          ? IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: _nameController.clear,
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
                      if (value == null || value.isEmpty) {
                        return 'Enter Id';
                      }
                      return null;
                    },
                    controller: _idController,
                    onChanged: (word) {
                      setState(() {
                        isIdIconVisible = (word ?? '').isNotEmpty;
                      });
                      _formKey.currentState!.fields['password']?.validate();
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Device Id',
                      suffixIcon: isIdIconVisible
                          ? IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: _idController.clear,
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
                        'Add Device',
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
