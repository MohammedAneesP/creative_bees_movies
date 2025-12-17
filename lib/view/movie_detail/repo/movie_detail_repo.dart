import 'package:creative_movie/core/constants/api_constants.dart';
import 'package:creative_movie/view/movie_detail/model/movie_detail_model.dart';
import 'package:http/http.dart' as http;

class MovieDetailRepo {
  static Future<MovieDetailModel> fetchMovieDetail(int movieId) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/movie/$movieId?api_key=${ApiConstants.apiKey}',
    );

    final response = await http.get(uri);

    // ✅ Success
    if (response.statusCode == 200) {
      return movieDetailModelFromJson(response.body);
    }

    // ❌ Error handling
    if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid TMDB token');
    }

    if (response.statusCode == 404) {
      throw Exception('Movie not found');
    }

    throw Exception('TMDB error ${response.statusCode}: ${response.body}');
  }
}
