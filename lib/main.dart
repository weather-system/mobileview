import 'package:flutter/material.dart';
import 'screens/weather_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        primarySwatch: Colors.blue, // Warna tema utama
      ),
      home: WeatherDashboard(), // Menampilkan layar utama
    );
  }
}
