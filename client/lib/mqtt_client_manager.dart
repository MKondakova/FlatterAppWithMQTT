import 'dart:convert';
import 'dart:developer' as L;
import 'dart:io';
import 'dart:math';

import 'package:client/models.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MQTTClientManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  MqttServerClient client = MqttServerClient.withPort(
      '192.168.43.113', 'mobile_client${Random().nextInt(1000)}', 1883);

  final clientBuilder = MqttClientPayloadBuilder();
  UserData? userData;
  DeviceData? deviceData;

  Future<int> connect() async {
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage().startClean();
    client.connectionMessage = connMessage;

    L.log('MQTT :: Connecting...');
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      L.log('MQTT :: client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      L.log('MQTT :: socket exception - $e');
      client.disconnect();
      return 2;
    }
    L.log('MQTT :: Connected...');
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      for (MqttReceivedMessage m in c) {
        L.log("New message from topic : ${m.topic}");
        final payload = m.payload as MqttPublishMessage;
        final content =
            MqttPublishPayload.bytesToStringAsString(payload.payload.message);

        if (m.topic == 'client/create/${userData?.userName}') {
          if (content == 'success') {
            userData!.successLogin();
          } else {
            userData!.loginFailed();
          }
        }

        if (m.topic == 'sensor/create/${deviceData?.data.id}') {
          L.log(content);
          if (content == 'success') {
            deviceData!.successLogin();
          } else {
            deviceData!.loginFailed();
          }
        }

        if (m.topic == 'client/login/${userData?.userName}') {
          if (content == 'success') {
            userData!.successLogin();
          } else {
            userData!.loginFailed();
          }
        }

        if (m.topic == 'sensor/${deviceData?.data.id}') {
          Map<String, dynamic> data = jsonDecode(content);
          L.log(data['state']);
          deviceData!.setValue(data['state']);
        }

        if (m.topic == 'client/${userData?.userName}') {
          Map<String, dynamic> data = jsonDecode(content);
          userData!
              .updateValue(data['guid'].toString(), data['state'].toString());
        }

        if (m.topic == 'client/subscriptions/${userData?.userName}') {
          List<dynamic> data = jsonDecode(content);
          List<Device> devices = <Device>[];
          for (Map<String, dynamic> d in data) {
            Map<String, dynamic> sensor = d['sensor'];
            Device device = Device(d['title'].toString(),
                sensor['guid'].toString(), sensor['state']);
            devices.add(device);
          }
          userData!.setDevices(devices);
        }
      }
    });

    return 0;
  }

  void disconnect() {
    client.disconnect();
  }

  Subscription? subscribe(String topic) {
    return client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void onConnected() {
    if (kDebugMode) {
      print('MQTTClient::Connected');
    }
  }

  void onDisconnected() {
    if (kDebugMode) {
      print('MQTTClient::Disconnected');
    }
  }

  void onSubscribed(String topic) {
    if (kDebugMode) {
      print('MQTTClient::Subscribed to topic: $topic');
    }
  }

  void pong() {
    if (kDebugMode) {
      print('MQTTClient::Ping response received');
    }
  }

  void publishMessage(String topic, MqttQos quality, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, quality, builder.payload!);
  }

  void registerUser(String login, String password) {
    String message = json.encode({"username": login, "password": password});
    Subscription? resultSubscription = subscribe('client/create/$login');
    if (resultSubscription == null) {
      throw Exception('Something went wrong with subscription');
    }
    userData!.silentSetName(login);
    userData!.startLogining();
    publishMessage('client/create', MqttQos.atLeastOnce, message);
  }

  void loginUser(String login, String password) {
    String message = json.encode({"username": login, "password": password});
    Subscription? resultSubscription = subscribe('client/login/$login');
    if (resultSubscription == null) {
      throw Exception('Something went wrong with subscription');
    }
    userData!.silentSetName(login);
    userData!.startLogining();
    publishMessage('client/login', MqttQos.atLeastOnce, message);
  }

  Future<void> registerDevice() async {
    final SharedPreferences prefs = await _prefs;
    String? uuid = prefs.getString('uuid');
    if (uuid == null) {
      uuid = const Uuid().v4();
      prefs.setString('uuid', uuid);
    }
    deviceData!.silentSetId(uuid);
    String message = json.encode(
        {"guid": deviceData!.data.id});

    Subscription? resultSubscription = subscribe('sensor/create/$uuid');
    if (resultSubscription == null) {
      throw Exception('Something went wrong with subscription');
    }
    deviceData!.startLogining();
    publishMessage('sensor/create', MqttQos.atLeastOnce, message);
  }

  // to device
  void giveAnOrder(String uuid, String newState) {
    String message = json.encode({'guid': uuid, 'state': newState});
    publishMessage('sensor/update', MqttQos.atLeastOnce, message);
  }

  void updateDevices() {
    String message = json.encode({'username': userData!.userName!});
    subscribe('client/subscriptions/${userData?.userName}');
    subscribe('client/${userData?.userName}');
    publishMessage('client/subscriptions', MqttQos.atLeastOnce, message);
  }

  void subscribeOnDevice(String name, String uuid) {
    String message = json.encode(
        {'sensorGuid': uuid, 'title': name, 'username': userData!.userName!});
    publishMessage('client/subscribe', MqttQos.atLeastOnce, message);
    updateDevices();
  }

  Future<void> changeState(String newState) async {
    final SharedPreferences prefs = await _prefs;
    final String uuid = prefs.getString('uuid')!;
    subscribe('sensor/${deviceData?.data.id}');
    String message = json.encode({'guid': uuid, 'state': newState});
    publishMessage('sensor/update', MqttQos.atLeastOnce, message);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return client.updates;
  }
}
