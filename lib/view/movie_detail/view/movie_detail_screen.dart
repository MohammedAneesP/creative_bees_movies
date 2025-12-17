import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/api_constants.dart';
import '../controller/movie_detail_controller.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieDetailController>().fetchMovieDetail(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, elevation: 0),
      body: Consumer<MovieDetailController>(
        builder: (context, controller, _) {
          // ----------------------------
          // LOADING
          // ----------------------------
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          // ----------------------------
          // ERROR
          // ----------------------------
          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Failed to load movie details',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      controller.fetchMovieDetail(widget.movieId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final movie = controller.movieDetail;
          if (movie == null) return const SizedBox();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ============================
                // HERO POSTER
                // ============================
                CachedNetworkImage(
                  imageUrl: '${ApiConstants.imageBaseUrl}${movie.posterPath}',
                  height: 420,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  placeholder: (context, _) => const SizedBox(
                    height: 420,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.redAccent),
                    ),
                  ),
                  errorWidget: (_, __, ___) => const SizedBox(
                    height: 420,
                    child: Icon(Icons.movie, color: Colors.white54, size: 60),
                  ),
                ),

                // ============================
                // CONTENT
                // ============================
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      Text(
                        movie.title ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // RATING + DATE + RUNTIME
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            (movie.voteAverage ?? 0).toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            movie.releaseDate
                                    ?.toIso8601String()
                                    .split('T')
                                    .first ??
                                '',
                            style: const TextStyle(color: Colors.white54),
                          ),
                          const SizedBox(width: 16),
                          if (movie.runtime != null)
                            Text(
                              '${movie.runtime} min',
                              style: const TextStyle(color: Colors.white54),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // GENRES
                      if (movie.genres != null && movie.genres!.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: movie.genres!
                              .map(
                                (g) => Chip(
                                  backgroundColor: Colors.grey.shade900,
                                  label: Text(
                                    g.name ?? '',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                      const SizedBox(height: 24),

                      // OVERVIEW
                      const Text(
                        'Overview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
