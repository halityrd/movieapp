import 'package:movieapp/models/movie_model.dart';
import 'package:movieapp/utils/movie_category.dart';

abstract class IMovieService {
  Future<List<MovieModel>> fetchMovies(MovieCategory category);
}
