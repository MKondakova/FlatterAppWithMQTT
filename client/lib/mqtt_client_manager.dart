import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/*
* Необходимо чтобы
* для клиента: состояние датчиков обновлялось при соотв. сообщении
* для датчика: состояние собственное обновлялось при соотв. сообщении
*
* каждая подписка вообще возвращает Subscription, у которого есть отдельный
* changes, надо работать с ней
*
* https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple
*
* */

class MQTTClientManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  MqttServerClient client =
      MqttServerClient.withPort('10.0.2.2', 'mobile_client', 1883);
  final clientBuilder = MqttClientPayloadBuilder();

  Future<int> connect() async {
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage().startClean();
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      if (kDebugMode) {
        print('MQTTClient::Client exception - $e');
      }
      client.disconnect();
    }

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
    publishMessage('client/create', MqttQos.atLeastOnce, message);
    //todo ожидание правильного ответа как-то через future?
  }

  Future<void> registerDevice() async {
    final SharedPreferences prefs = await _prefs;
    String? uuid = prefs.getString('uuid');
    if (uuid == null) {
      uuid = const Uuid().v4();
      prefs.setString('uuid', uuid);
    }
    String message = json.encode({"guid": uuid, "title": 'todo'});

    Subscription? resultSubscription = subscribe('sensor/create/$uuid');
    if (resultSubscription == null) {
      throw Exception('Something went wrong with subscription');
    }
    publishMessage('sensor/create', MqttQos.atLeastOnce, message);
    //todo ожидание правильного ответа как-то через future?

    // если все норм то подписываемся на наш топик с данными и публикуем что-то
    // дефолтное
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
