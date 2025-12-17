import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  /// v3 API Key (SHORT)
  static String get apiKey {
    final key = dotenv.env['TMDB_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('TMDB_API_KEY not found in .env');
    }
    return key;
  }

  /// v4 Read Token (LONG JWT) – optional
  static String get readToken {
    final token = dotenv.env['TMDB_READ_TOKEN'];
    if (token == null || token.isEmpty) {
      throw Exception('TMDB_READ_TOKEN not found in .env');
    }
    return token;
  }
}
