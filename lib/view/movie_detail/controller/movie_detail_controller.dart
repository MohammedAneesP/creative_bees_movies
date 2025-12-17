import 'package:flutter/material.dart';
import '../model/movie_detail_model.dart';
import '../repo/movie_detail_repo.dart';

class MovieDetailController extends ChangeNotifier {
  MovieDetailModel? movieDetail;

  bool isLoading = false;
  String? error;

  /// Fetch movie details by ID
  Future<void> fetchMovieDetail(int movieId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      movieDetail =
          await MovieDetailRepo.fetchMovieDetail(movieId);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// Optional: clear state when leaving screen
  void clear() {
    movieDetail = null;
    error = null;
    isLoading = false;
    notifyListeners();
  }
}
