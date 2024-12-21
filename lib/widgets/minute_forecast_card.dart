// widgets/per_minute_forecast_card.dart
import 'package:flutter/material.dart';

class PerMinuteForecastCard extends StatelessWidget {
  final String time;
  final String temp;

  const PerMinuteForecastCard({
    Key? key,
    required this.time,
    required this.temp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 4),
          Icon(Icons.cloud, color: Colors.white),
          SizedBox(height: 4),
          Text(
            '$temp°',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
