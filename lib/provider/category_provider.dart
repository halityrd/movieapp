import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:movieapp/models/category_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movieapp/repositories/category_repository.dart';
import 'package:movieapp/services/i_category_service.dart';
import 'package:movieapp/services/category_service_tmdb.dart';
import 'package:movieapp/services/category_service_mock.dart';

// HTTP client
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Mock mu gerçek mi?
final useMockCategoriesProvider = Provider<bool>((ref) => false);

// Service seçimi
final categoryServiceProvider = Provider<ICategoryService>((ref) {
  if (ref.watch(useMockCategoriesProvider)) {
    return CategoryServiceMock();
  }
  return CategoryServiceTmdb(
    client: ref.watch(httpClientProvider),
    baseUrl: 'https://api.themoviedb.org/3',
    apiKey: dotenv.env['TMDB_API_TOKEN'] ?? '', // .env'den de çekebilirsin
  );
});

// Repository
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(service: ref.watch(categoryServiceProvider));
});

// Liste provider
final categoryListProvider = FutureProvider.autoDispose<List<CategoryModel>>((
  ref,
) {
  return ref.watch(categoryRepositoryProvider).getCategories();
});
