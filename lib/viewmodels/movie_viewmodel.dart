import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../utils/movie_category.dart';

class MovieViewModel extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieRepository repository;

  MovieViewModel(this.repository) : super(const AsyncValue.loading()) {
    loadMovies(MovieCategory.nowPlaying);
  }

  Future<void> loadMovies(MovieCategory category) async {
    state = const AsyncValue.loading();

    try {
      final movies = await repository.fetchMovies(category);
      state = AsyncValue.data(movies);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
