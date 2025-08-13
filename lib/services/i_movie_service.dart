import 'package:movieapp/models/movie.dart';
import 'package:movieapp/utils/movie_category.dart';

abstract class IMovieService {
  Future<List<Movie>> fetchMovies(MovieCategory category);
}
