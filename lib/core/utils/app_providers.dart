import 'package:creative_movie/view/home_screen/controller/home_controller.dart';
import 'package:creative_movie/view/home_screen/repo/home_repo.dart';
import 'package:creative_movie/view/movie_detail/controller/movie_detail_controller.dart';
import 'package:creative_movie/view/movie_detail/repo/movie_detail_repo.dart';
import 'package:creative_movie/view/search/controller/search_controller.dart';
import 'package:creative_movie/view/search/repo/search_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    Provider(create: (_) => HomeRepo()),
    Provider(create: (_) => MovieDetailRepo()),
    Provider(create: (_) => SearchRepo()),

    ChangeNotifierProvider(create: (_) => PopularMoviesController()),
    ChangeNotifierProvider(create: (_) => MovieDetailController()),
    ChangeNotifierProvider(create: (_) => SearchMoviesController()),
  ];
}
