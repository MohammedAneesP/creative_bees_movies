import 'dart:async';
import 'package:creative_movie/view/search/repo/search_model.dart';
import 'package:flutter/material.dart';
import '../model/search_model.dart';

class SearchMoviesController extends ChangeNotifier {
  // ----------------------------
  // DATA
  // ----------------------------
  List<Result> results = [];

  // ----------------------------
  // STATE
  // ----------------------------
  bool isLoading = false;
  bool isFetchingMore = false;
  String? error;

  // ----------------------------
  // PAGINATION
  // ----------------------------
  int _page = 1;
  int _totalPages = 1;
  String _query = '';

  Timer? _debounce;

  bool get hasMore => _page <= _totalPages;

  // ----------------------------
  // QUERY HANDLER (DEBOUNCE)
  // ----------------------------
  void onQueryChanged(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        results.clear();
        error = null;
        isLoading = false;
        notifyListeners(); // 🔴 REQUIRED
        return;
      }

      _query = query.trim();
      fetchSearchResults(refresh: true);
    });
  }

  // ----------------------------
  // FETCH SEARCH RESULTS
  // ----------------------------
  Future<void> fetchSearchResults({bool refresh = false}) async {
    if (isLoading || isFetchingMore) return;

    if (refresh) {
      _page = 1;
      _totalPages = 1;
      results.clear();
      error = null;
      isLoading = true;
      notifyListeners(); // 🔴 REQUIRED
    } else {
      if (!hasMore) return;
      isFetchingMore = true;
      notifyListeners(); // 🔴 REQUIRED
    }

    try {
      final SearchModel response = await SearchRepo.searchMovies(
        query: _query,
        page: _page,
      );

      _totalPages = response.totalPages ?? 1;
      results.addAll(response.results ?? []);
      _page++;
    } catch (e) {
      error = 'Search failed. Please try again.';
    }

    isLoading = false;
    isFetchingMore = false;
    notifyListeners(); // 🔴 REQUIRED
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
