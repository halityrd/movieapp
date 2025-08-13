// lib/services/movie_service_tmdb.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieapp/models/movie_model.dart';
import 'package:movieapp/utils/movie_category.dart';
import 'package:movieapp/services/i_movie_service.dart';

class MovieServiceTmdb implements IMovieService {
  final http.Client client;
  final String baseUrl;
  final String apiKey;

  MovieServiceTmdb({
    required this.client,
    required this.baseUrl,
    required this.apiKey,
  });

  @override
  Future<List<MovieModel>> fetchMovies(MovieCategory category) {
    final fetcher = {
      MovieCategory.popular: () => _fetchFromTMDB('popular'),
      MovieCategory.topRated: () => _fetchFromTMDB('top_rated'),
      MovieCategory.upcoming: () => _fetchFromTMDB('upcoming'),
      MovieCategory.nowPlaying: () => _fetchFromTMDB('now_playing'),
    }[category];

    if (fetcher == null) {
      throw Exception('Unknown category: $category');
    }
    return fetcher();
  }

  Future<List<MovieModel>> _fetchFromTMDB(String path) async {
    if (apiKey.isEmpty) {
      throw Exception('API key eksik. .env dosyasını kontrol et.');
    }

    final url = Uri.parse('$baseUrl/movie/$path?language=en-US&page=1');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('TMDB API hatası: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = (data['results'] as List?) ?? [];

    return list.map((json) => MovieModel.fromJson(json)).toList();
  }
}
