import 'package:movieapp/models/category_model.dart';

abstract class ICategoryService {
  Future<List<CategoryModel>> fetchCategories();
}
