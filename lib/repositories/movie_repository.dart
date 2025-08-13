// lib/repositories/movie_repository.dart
import 'package:movieapp/models/movie_model.dart';
import 'package:movieapp/services/i_movie_service.dart';
import 'package:movieapp/utils/movie_category.dart';

class MovieRepository {
  final IMovieService service;
  MovieRepository({required this.service});

  Future<List<MovieModel>> getMovies(MovieCategory category) async {
    return service.fetchMovies(category);
  }
}
