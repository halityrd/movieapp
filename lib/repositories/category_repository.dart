import 'package:movieapp/models/category_model.dart';
import 'package:movieapp/services/i_category_service.dart';

class CategoryRepository {
  final ICategoryService service;

  CategoryRepository({required this.service});

  Future<List<CategoryModel>> getCategories() {
    return service.fetchCategories();
  }
}
