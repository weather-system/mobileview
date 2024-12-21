// screens/weather_history.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/api_service.dart';
import '../models/weather_data.dart';

class WeatherHistory extends StatefulWidget {
  @override
  _WeatherHistoryState createState() => _WeatherHistoryState();
}

class _WeatherHistoryState extends State<WeatherHistory> {
  final ApiService apiService = ApiService();
  late Future<List<WeatherData>> futureWeatherData;

  @override
  void initState() {
    super.initState();
    futureWeatherData = apiService.fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather History'),
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder<List<WeatherData>>(
        future: futureWeatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 50),
                  SizedBox(height: 8),
                  Text(
                    'Failed to load weather data.\nPlease check your connection.',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.blue[900]),
              ),
            );
          }

          // Filter data untuk 7 hari terakhir
          final last7Days = snapshot.data!
              .where((weather) =>
          weather.createdAt != null &&
              weather.createdAt!.isAfter(
                  DateTime.now().subtract(Duration(days: 7))))
              .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Weather History (Last 7 Days)',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildChartCard(
                    title: 'Temperature (°C)',
                    series: [
                      ColumnSeries<WeatherData, String>(
                        dataSource: last7Days,
                        xValueMapper: (WeatherData data, _) =>
                        data.createdAt!.toIso8601String().split('T')[0],
                        yValueMapper: (WeatherData data, _) => data.suhu,
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                        name: 'Temperature',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildChartCard(
                    title: 'Humidity (%)',
                    series: [
                      ColumnSeries<WeatherData, String>(
                        dataSource: last7Days,
                        xValueMapper: (WeatherData data, _) =>
                        data.createdAt!.toIso8601String().split('T')[0],
                        yValueMapper: (WeatherData data, _) => data.kelembapan,
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                        name: 'Humidity',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildChartCard(
                    title: 'Wind Speed (km/h)',
                    series: [
                      ColumnSeries<WeatherData, String>(
                        dataSource: last7Days,
                        xValueMapper: (WeatherData data, _) =>
                        data.createdAt!.toIso8601String().split('T')[0],
                        yValueMapper: (WeatherData data, _) =>
                        data.kecepatanAngin,
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                        name: 'Wind Speed',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildChartCard(
                    title: 'Light Intensity (lx)',
                    series: [
                      ColumnSeries<WeatherData, String>(
                        dataSource: last7Days,
                        xValueMapper: (WeatherData data, _) =>
                        data.createdAt!.toIso8601String().split('T')[0],
                        yValueMapper: (WeatherData data, _) =>
                        data.intensitasCahaya,
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(8),
                        name: 'Light Intensity',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildChartCard(
                    title: 'Rainfall (mm)',
                    series: [
                      ColumnSeries<WeatherData, String>(
                        dataSource: last7Days,
                        xValueMapper: (WeatherData data, _) =>
                        data.createdAt!.toIso8601String().split('T')[0],
                        yValueMapper: (WeatherData data, _) =>
                        data.curahHujan,
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(8),
                        name: 'Rainfall',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required List<ColumnSeries<WeatherData, String>> series,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.blue[900],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(color: Colors.black),
              ),
              legend: Legend(
                isVisible: false,
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: series,
            ),
          ),
        ],
      ),
    );
  }
}
