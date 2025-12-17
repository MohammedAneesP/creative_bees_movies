import 'package:creative_movie/view/home_screen/model/popular_model.dart';
import 'package:creative_movie/view/home_screen/repo/home_repo.dart';
import 'package:flutter/material.dart';

class PopularMoviesController extends ChangeNotifier {
  // DATA
  final List<Result> movies = [];

  // STATES
  bool isLoading = false;
  bool isFetchingMore = false;
  String? error;

  // PAGINATION
  int _page = 1;
  int _totalPages = 1;

  bool get hasMore => _page <= _totalPages;

  Future<void> fetchPopularMovies({bool refresh = false}) async {
    if (isLoading || isFetchingMore) return;

    if (refresh) {
      _page = 1;
      _totalPages = 1;
      movies.clear();
      error = null;
      isLoading = true;
    } else {
      if (!hasMore) return;
      isFetchingMore = true;
    }

    notifyListeners();

    try {
      final response = await HomeRepo.fetchPopularMovies(page: _page);

      _totalPages = response.totalPages ?? 1;

      final newMovies = response.results ?? [];

      movies.addAll(newMovies);

      _page++; // ✅ increment ONLY after success
      error = null;
    } catch (e) {
      error = 'Network issue. Please try again.';
    }

    isLoading = false;
    isFetchingMore = false;
    notifyListeners();
  }
}
