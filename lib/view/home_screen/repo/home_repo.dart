import 'dart:developer';

import 'package:creative_movie/core/constants/api_constants.dart';
import 'package:creative_movie/view/home_screen/model/popular_model.dart';
import 'package:http/http.dart' as http;

class HomeRepo {
  static Future<PopularMoviesModel> fetchPopularMovies({int page = 1}) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/movie/popular'
      '?api_key=${ApiConstants.apiKey}'
      '&page=$page',
    );

    final response = await http.get(uri);

    // ✅ Success
    if (response.statusCode == 200) {
      return popularMoviesModelFromJson(response.body);
    }

    // ❌ Error handling
    if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid TMDB token');
    }

    if (response.statusCode == 404) {
      throw Exception('Endpoint not found');
    }
    log('TMDB error ${response.statusCode}: ${response.body}');
    throw Exception('TMDB error ${response.statusCode}: ${response.body}');
  }
}
