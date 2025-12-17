import 'package:cached_network_image/cached_network_image.dart';
import 'package:creative_movie/core/routes/app_routes.dart';
import 'package:creative_movie/view/home_screen/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/api_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<PopularMoviesController>(
        context,
        listen: false,
      );
      controller.fetchPopularMovies();

      _scrollController.addListener(_onScroll);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final controller = context.read<PopularMoviesController>();

    if (position.pixels >= position.maxScrollExtent - 200) {
      if (controller.hasMore &&
          !controller.isFetchingMore &&
          !controller.isLoading) {
        controller.fetchPopularMovies();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Creative Movie',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.search);
            },
          ),
        ],
      ),
      body: Consumer<PopularMoviesController>(
        builder: (context, controller, _) {
          // ----------------------------
          // INITIAL LOADING
          // ----------------------------
          if (controller.isLoading && controller.movies.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          // ----------------------------
          // ERROR STATE
          // ----------------------------
          if (controller.error != null && controller.movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, color: Colors.white54, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Failed to load movies',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.error!,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.fetchPopularMovies(refresh: true);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // ----------------------------
          // MOVIE GRID
          // ----------------------------
          return RefreshIndicator(
            color: Colors.redAccent,
            onRefresh: () => controller.fetchPopularMovies(refresh: true),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount:
                  controller.movies.length + (controller.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // ----------------------------
                // BOTTOM LOADER
                // ----------------------------
                if (index == controller.movies.length) {
                  if (controller.error != null) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              'Failed to load more movies',
                              style: TextStyle(color: Colors.white54),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                controller.fetchPopularMovies();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  );
                }

                final movie = controller.movies[index];

                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.movieDetail,
                    arguments: movie.id,
                  ),
                  child: _MovieCard(
                    title: movie.title ?? '',
                    posterPath: movie.posterPath,
                    rating: movie.voteAverage ?? 0,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final String title;
  final String? posterPath;
  final double rating;

  const _MovieCard({
    required this.title,
    required this.posterPath,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: posterPath != null
                ? CachedNetworkImage(
                    imageUrl: '${ApiConstants.imageBaseUrl}$posterPath',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.redAccent,
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.movie, color: Colors.white54),
                    ),
                  )
                : const Center(child: Icon(Icons.movie, color: Colors.white54)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.star, size: 14, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
