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
      '192.168.0.14', 'mobile_client${Random().nextInt(1000)}', 1883);

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
    }
    L.log('MQTT :: Connected...');
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      for (MqttReceivedMessage m in c) {
        L.log("New message from topic : ${m.topic}");
        final payload = m.payload as MqttPublishMessage;
        final content =
            MqttPublishPayload.bytesToStringAsString(payload.payload.message);

        if (m.topic == 'client/create/${userData?.userName}') {
          //todo check what message
          userData!.successLogin();
        }

        if (m.topic == 'sensor/create/${deviceData?.data!.id}') {
          changeState(deviceData!.data!.value);
        }

        if (m.topic == 'sensor/${deviceData?.data!.id}') {
          Map<String, dynamic> data = jsonDecode(content);
          deviceData!.setValue(data['state']);
        }

        if (m.topic == 'client/${userData?.userName}') {
          Map<String, dynamic> data = jsonDecode(content);
          userData!.updateValue(data['guid'], data['state']);
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

  Future<void> registerDevice() async {
    final SharedPreferences prefs = await _prefs;
    String? uuid = prefs.getString('uuid');
    if (uuid == null) {
      uuid = const Uuid().v4();
      prefs.setString('uuid', uuid);
    }
    deviceData!.silentSetId(uuid);
    String message = json.encode(
        {"guid": deviceData!.data!.id, "title": deviceData!.data!.name});

    Subscription? resultSubscription = subscribe('sensor/create/$uuid');
    if (resultSubscription == null) {
      throw Exception('Something went wrong with subscription');
    }
    publishMessage('sensor/create', MqttQos.atLeastOnce, message);
  }

  // to device
  void giveAnOrder(String uuid, String newState) {
    String message = json.encode({'state': newState});
    publishMessage('sensor/$uuid', MqttQos.atLeastOnce, message);
  }

  void updateDevices() {
    /* посылаем запрос в топик client/---
    * ждем ответа в виде списка devises (в json)
    * когда он приходит, сохраняем в sharedPrefs
    * и возвращаем, разрешая future */
  }

  Future<void> changeState(String newState) async {
    final SharedPreferences prefs = await _prefs;
    final String uuid = prefs.getString('uuid')!;
    String message = json.encode({'state': newState});
    publishMessage('sensor/$uuid', MqttQos.atLeastOnce, message);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return client.updates;
  }
}
