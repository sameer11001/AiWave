class WaveConfig {
  static const String ipAddress = "http://10.0.2.2";
  // static const String ipAddress = "http://127.0.0.1";
  static const String port = "7651";

  static get baseUrl => '$ipAddress:$port';
}
