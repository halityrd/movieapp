import 'package:movieapp/models/movie_model.dart';
import 'package:movieapp/utils/movie_category.dart';
import 'package:movieapp/services/i_movie_service.dart';

class MockMovieService implements IMovieService {
  @override
  Future<List<MovieModel>> fetchMovies(MovieCategory category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      MovieModel(
        id: 1,
        title: 'Mock Movie 1',
        overview: 'A mock movie.',
        posterPath: '',
        backdropPath: '',
        voteAverage: 0.0,
        releaseDate: '2025-01-01',
      ),
      MovieModel(
        id: 2,
        title: 'Mock Movie 2',
        overview: 'Another mock movie.',
        posterPath: '',
        backdropPath: '',
        voteAverage: 0.0,
        releaseDate: '2025-01-02',
      ),
    ];
  }
}
