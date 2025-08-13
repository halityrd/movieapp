import 'package:movieapp/services/tmdb_service.dart';

import 'package:movieapp/models/movie.dart';
import 'package:movieapp/utils/movie_category.dart';
import 'package:movieapp/services/i_movie_service.dart';

class MovieRepository {
  final IMovieService _service;

  MovieRepository({IMovieService? service})
    : _service = service ?? TMDBService();

  Future<List<Movie>> fetchMovies(MovieCategory category) {
    return _service.fetchMovies(category);
  }
}
