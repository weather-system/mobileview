import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class WeatherDashboard extends StatefulWidget {
  @override
  _WeatherDashboardState createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  double temperature = 0.0;
  double humidity = 0.0;
  double windSpeed = 0.0;
  String weatherDescription = '';

  late mqtt.MqttClient mqttClient;
  String broker = 'broker.mqtt-dashboard.com'; // Ganti dengan broker MQTT yang sesuai
  String topic = 'weather/data'; // Ganti dengan topik yang sesuai untuk cuaca

  @override
  void initState() {
    super.initState();
    _initializeMQTT();
  }

  // Fungsi untuk menghubungkan MQTT dan mendengarkan pesan
  Future<void> _initializeMQTT() async {
    mqttClient = mqtt.MqttClient(broker, '');
    mqttClient.logging(on: true);

    try {
      await mqttClient.connect();
      print('Connected to MQTT broker'); // Menambahkan print jika berhasil terhubung
      mqttClient.subscribe(topic, mqtt.MqttQos.atMostOnce);

      // Mendengarkan pesan yang diterima dengan null-aware operator
      mqttClient.updates?.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>> event) {
        final mqtt.MqttPublishMessage message = event[0].payload as mqtt.MqttPublishMessage;
        final payload = utf8.decode(message.payload.message);

        setState(() {
          // Mengupdate data cuaca yang diterima dari MQTT
          var data = jsonDecode(payload);
          temperature = data['temperature'];
          humidity = data['humidity'];
          windSpeed = data['windSpeed'];
          weatherDescription = data['weatherDescription'];
        });
      });
    } catch (e) {
      print('Error connecting to MQTT: $e');
    }
  }

  @override
  void dispose() {
    mqttClient.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Dashboard'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Text('Temperature: ${temperature}°C', style: TextStyle(fontSize: 24)),
          Text('Humidity: ${humidity}%', style: TextStyle(fontSize: 24)),
          Text('Wind Speed: ${windSpeed} km/h', style: TextStyle(fontSize: 24)),
          Text('Weather: $weatherDescription', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
