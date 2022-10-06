import 'dart:math';

import 'package:flutter/cupertino.dart';

class DeviceData extends ChangeNotifier {
  Device? data;

  void setValue(String newValue) {
    if (data != null){
      data!.value = newValue;
      notifyListeners();
    }
  }
  
  void setDeviceData(Device data){
    this.data = data;
    notifyListeners();
  }

  // todo also name
  void silentSetId(String id) {
    Device d = Device("name${Random().nextInt(100)}", id, "value", true);
    data = d;
  }
}

class UserData extends ChangeNotifier {
  List<Device> devices = <Device>[];
  String? userName;
  int isLoggedIn = 0; //0 - now inactive; 1 - in process; 2 - success; 3 - failure;

  void updateValue(String deviceId, String newValue) {
    for (Device d in devices){
      if (d.id == deviceId) {
        d.value = newValue;
        notifyListeners();
        return;
      }
    }
  }

  void successLogin() {
    isLoggedIn = 2;
    notifyListeners();
  }

  void loginFailed() {
    isLoggedIn = 3;
    userName = null;
    notifyListeners();
  }

  void startLogining() {
    isLoggedIn = 1;
    notifyListeners();
  }

  void silentSetName(String name) {
    userName = name;
  }
}

class Device {
  String name;
  String id;
  String value;
  bool isEnabled;

  Device(this.name, this.id, this.value, this.isEnabled);
}
