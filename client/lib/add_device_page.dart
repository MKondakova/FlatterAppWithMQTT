import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'models.dart';
import 'mqtt_client_manager.dart';

class AddDevicePage extends StatelessWidget {
  const AddDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      mqtt.subscribeOnDevice(_formKey.currentState!.fields['name']!.value,
      _formKey.currentState!.fields['id']!.value);
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
                  const EdgeInsets.symmetric(vertical: 80.0, horizontal: 10.0),
              child: const Text(
                'Subscribe on new device:',
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
                    name: 'name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter device name';
                      }
                      return null;
                    },
                    controller: _nameController,
                    onChanged: (word) {
                      setState(() {
                        isNameIconVisible = (word ?? '').isNotEmpty;
                      });
                      _formKey.currentState!.fields['name']?.validate();
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
                    name: 'id',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter id';
                      }
                      return null;
                    },
                    controller: _idController,
                    onChanged: (word) {
                      setState(() {
                        isIdIconVisible = (word ?? '').isNotEmpty;
                      });
                      _formKey.currentState!.fields['id']?.validate();
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Device id',
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
                      onPressed: _validateForm,
                      child: const Text(
                        'Add Device',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    )),
              ],
            ),
          )
        ]));
  }
}
