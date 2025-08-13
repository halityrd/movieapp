import 'package:movieapp/models/category_model.dart';
import 'i_category_service.dart';

class CategoryServiceMock implements ICategoryService {
  @override
  Future<List<CategoryModel>> fetchCategories() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return const [
      CategoryModel(id: 28, name: 'Action'),
      CategoryModel(id: 35, name: 'Comedy'),
      CategoryModel(id: 18, name: 'Drama'),
      CategoryModel(id: 878, name: 'Sci-Fi'),
      CategoryModel(id: 27, name: 'Horror'),
      CategoryModel(id: 16, name: 'Animation'),
    ];
  }
}
