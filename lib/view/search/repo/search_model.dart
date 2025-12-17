import 'package:creative_movie/core/constants/api_constants.dart';
import 'package:creative_movie/view/search/model/search_model.dart';
import 'package:http/http.dart' as http;

class SearchRepo {
  static Future<SearchModel> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/search/movie'
      '?api_key=${ApiConstants.apiKey}'
      '&query=${Uri.encodeQueryComponent(query)}'
      '&page=$page',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return searchModelFromJson(response.body);
    }

    throw Exception(
      'Search failed (${response.statusCode})',
    );
  }
}
