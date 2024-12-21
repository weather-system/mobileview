// models/weather_data.dart
class WeatherData {
  final int id;
  final double kecepatanAngin;
  final String arahAngin;
  final double curahHujan;
  final double suhu;
  final double kelembapan;
  final double intensitasCahaya;
  final DateTime? createdAt;

  WeatherData({
    required this.id,
    required this.kecepatanAngin,
    required this.arahAngin,
    required this.curahHujan,
    required this.suhu,
    required this.kelembapan,
    required this.intensitasCahaya,
    this.createdAt,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      id: json['id'],
      kecepatanAngin: json['kecepatan_angin'].toDouble(),
      arahAngin: json['arah_angin'],
      curahHujan: json['curah_hujan'].toDouble(),
      suhu: json['suhu'].toDouble(),
      kelembapan: json['kelembapan'].toDouble(),
      intensitasCahaya: json['intensitas_cahaya'].toDouble(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }
}
