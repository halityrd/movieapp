import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/models/movie.dart';
import 'package:movieapp/repositories/movie_repository.dart';
import 'package:movieapp/services/tmdb_service.dart';
import 'package:movieapp/services/i_movie_service.dart';
import 'package:movieapp/viewmodels/movie_viewmodel.dart';

final movieServiceProvider = Provider<IMovieService>((ref) {
  return TMDBService(); // testte override edilebilir
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final service = ref.read(movieServiceProvider);
  return MovieRepository(service: service);
});

final movieViewModelProvider =
    StateNotifierProvider<MovieViewModel, AsyncValue<List<Movie>>>(
      (ref) => MovieViewModel(ref.read(movieRepositoryProvider)),
    );
