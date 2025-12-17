import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../controller/search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final controllerWatch = context.watch<SearchMoviesController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: controllerWatch.onQueryChanged,
        ),
      ),
      body: Consumer<SearchMoviesController>(
        builder: (context, controller, child) =>
            controller.isLoading && controller.results.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: Colors.redAccent),
              )
            : controller.results.isEmpty
            ? const Center(
                child: Text(
                  'Start typing to search movies',
                  style: TextStyle(color: Colors.white54),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.results.length,
                itemBuilder: (context, index) {
                  final movie = controller.results[index];

                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.movieDetail,
                      arguments: movie.id,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${ApiConstants.imageBaseUrl}${movie.posterPath}',
                              fit: BoxFit.cover,
                              placeholder: (_, __) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.redAccent,
                                ),
                              ),
                              errorWidget: (_, __, ___) => const Icon(
                                Icons.movie,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          movie.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
