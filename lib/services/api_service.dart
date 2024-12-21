// services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_data.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.81.181:8000/api/get/weather-data';

  // Fungsi untuk mengambil data cuaca dari API
  Future<List<WeatherData>> fetchWeatherData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      return data.map((item) => WeatherData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Fungsi untuk menentukan kondisi cuaca berdasarkan parameter
  String determineSkyCondition(WeatherData weather) {
    if (weather.suhu >= 30 && weather.kelembapan <= 50 && weather.kecepatanAngin <= 10) {
      return "Cuaca Panas: Suhu tinggi dan kelembapan rendah. Pastikan untuk tetap terhidrasi.";
    } else if (weather.suhu >= 25 &&
        weather.suhu <= 30 &&
        weather.kelembapan >= 60 &&
        weather.kelembapan <= 80 &&
        weather.kecepatanAngin >= 10 &&
        weather.kecepatanAngin <= 20) {
      return "Cuaca Berawan: Langit terlihat tertutup awan, tetapi belum ada tanda-tanda hujan.";
    } else if (weather.suhu >= 23 &&
        weather.suhu <= 28 &&
        weather.kelembapan >= 80 &&
        weather.kecepatanAngin >= 15 &&
        weather.kecepatanAngin <= 30) {
      return "Mau Hujan: Udara terasa lembap, awan terlihat gelap, dan ada kemungkinan hujan dalam waktu dekat.";
    } else if (weather.suhu >= 20 &&
        weather.suhu <= 25 &&
        weather.kelembapan >= 90 &&
        weather.kecepatanAngin > 20) {
      return "Hujan: Curah hujan berlangsung, bisa ringan, sedang, hingga lebat.";
    } else {
      return "Kondisi Cuaca Tidak Diketahui.";
    }
  }
}
