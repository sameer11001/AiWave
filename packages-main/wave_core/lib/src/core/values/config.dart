class WaveConfig {
  static String ipAddress = "http://10.0.2.2";
  static const String port = "7651";

  static get baseUrl => '$ipAddress:$port';
}
