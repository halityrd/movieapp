import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movieapp/models/movie.dart';
import 'package:movieapp/utils/movie_category.dart';
import 'package:movieapp/services/i_movie_service.dart';

class TMDBService implements IMovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiToken;

  TMDBService({String? token})
    : _apiToken = token ?? dotenv.env['TMDB_API_TOKEN'] ?? '';

  @override
  Future<List<Movie>> fetchMovies(MovieCategory category) {
    final map = {
      MovieCategory.popular: fetchPopularMovies,
      MovieCategory.topRated: fetchTopRatedMovies,
      MovieCategory.upcoming: fetchUpcomingMovies,
      MovieCategory.nowPlaying: fetchNowPlayingMovies,
    };

    final fetcher = map[category];
    if (fetcher != null) {
      return fetcher();
    } else {
      throw Exception('Unknown category: $category');
    }
  }

  Future<List<Movie>> fetchPopularMovies() async {
    return _fetchFromTMDB('popular');
  }

  Future<List<Movie>> fetchTopRatedMovies() async {
    return _fetchFromTMDB('top_rated');
  }

  Future<List<Movie>> fetchUpcomingMovies() async {
    return _fetchFromTMDB('upcoming');
  }

  Future<List<Movie>> fetchNowPlayingMovies() async {
    return _fetchFromTMDB('now_playing');
  }

  Future<List<Movie>> _fetchFromTMDB(String path) async {
    if (_apiToken.isEmpty) {
      throw Exception('API token eksik. .env dosyasını kontrol et.');
    }

    final url = Uri.parse('$_baseUrl/movie/$path?language=en-US&page=1');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_apiToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('TMDB API hatası: ${response.statusCode}');
    }
  }
}
