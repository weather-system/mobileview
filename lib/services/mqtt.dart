import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MqttConnectionPage(),
    );
  }
}

class MqttConnectionPage extends StatefulWidget {
  @override
  _MqttConnectionPageState createState() => _MqttConnectionPageState();
}

class _MqttConnectionPageState extends State<MqttConnectionPage> {
  late MqttServerClient client;
  String status = "Disconnected";

  @override
  void initState() {
    super.initState();
    _connectToMqtt();
  }

  Future<void> _connectToMqtt() async {
    client = MqttServerClient('broker.hivemq.com', 'flutter_client');
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;

    final MqttConnectMessage connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .keepAliveFor(20)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      print('Connecting to MQTT broker...');
      await client.connect();
    } catch (e) {
      print('Connection failed: $e');
      client.disconnect();
    }
  }

  void _onConnected() {
    setState(() {
      status = "Connected";
    });
    print('Connected to MQTT broker');
    client.subscribe('zahra/suhu', MqttQos.atMostOnce); // QoS 0
  }

  void _onDisconnected() {
    setState(() {
      status = "Disconnected";
    });
    print('Disconnected from MQTT broker');
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void _publishMessage(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage('zahra/suhu', MqttQos.atMostOnce, builder.payload!); // QoS 0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MQTT Connection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connection Status: $status'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _publishMessage("1"), // Contoh payload
              child: Text('Publish Payload'),
            ),
          ],
        ),
      ),
    );
  }
}
