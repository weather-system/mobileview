// widgets/weather_detail_card.dart
import 'package:flutter/material.dart';

class WeatherDetailCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const WeatherDetailCard({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        SizedBox(height: 8),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
