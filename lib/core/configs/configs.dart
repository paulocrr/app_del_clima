import 'package:flutter_dotenv/flutter_dotenv.dart';

class Configs {
  static String weatherApiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
}
