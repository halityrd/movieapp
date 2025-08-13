import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/models/movie_model.dart';
import 'package:movieapp/features/home/providers/movie_provider.dart';
import 'package:movieapp/utils/movie_category.dart';

class MovieViewModel extends StateNotifier<AsyncValue<List<MovieModel>>> {
  MovieViewModel(this.ref) : super(const AsyncValue.loading()) {
    fetchMovies(MovieCategory.nowPlaying);
  }

  final Ref ref;

  Future<void> fetchMovies(MovieCategory category) async {
    state = const AsyncValue.loading();
    try {
      final movies = await ref
          .read(movieRepositoryProvider)
          .getMovies(category);
      state = AsyncValue.data(movies);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final movieViewModelProvider =
    StateNotifierProvider<MovieViewModel, AsyncValue<List<MovieModel>>>(
      (ref) => MovieViewModel(ref),
    );
