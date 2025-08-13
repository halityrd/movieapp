import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieapp/models/category_model.dart';
import 'i_category_service.dart';

class CategoryServiceTmdb implements ICategoryService {
  final http.Client client;
  final String baseUrl;
  final String apiKey;

  CategoryServiceTmdb({
    required this.client,
    required this.baseUrl,
    required this.apiKey,
  });

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    if (apiKey.isEmpty) throw Exception('API key eksik.');

    final url = Uri.parse('$baseUrl/genre/movie/list?language=en-US');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = (data['genres'] as List?) ?? [];
      return list
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('TMDB API hatası: ${response.statusCode}');
    }
  }
}
