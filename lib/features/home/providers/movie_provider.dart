// lib/provider/movie_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movieapp/models/movie_model.dart';
import 'package:movieapp/repositories/movie_repository.dart';
import 'package:movieapp/services/i_movie_service.dart';
import 'package:movieapp/services/movie_service_tmdb.dart';
import 'package:movieapp/services/mock_movie_service.dart';
import 'package:movieapp/utils/movie_category.dart';

final httpClientProvider = Provider<http.Client>(
  (ref) => http.Client(),
); // global ise bunu kaldır ve globali kullan

final useMockMoviesProvider = Provider<bool>((ref) => false);

final movieServiceProvider = Provider<IMovieService>((ref) {
  if (ref.watch(useMockMoviesProvider)) {
    return MockMovieService();
  }
  return MovieServiceTmdb(
    client: ref.watch(httpClientProvider),
    baseUrl: 'https://api.themoviedb.org/3',
    apiKey: dotenv.env['TMDB_API_TOKEN'] ?? '',
  );
});

final movieRepositoryProvider = Provider<MovieRepository>(
  (ref) => MovieRepository(service: ref.watch(movieServiceProvider)),
);

final movieListProvider = FutureProvider.family
    .autoDispose<List<MovieModel>, MovieCategory>((ref, category) {
      return ref.watch(movieRepositoryProvider).getMovies(category);
    });
