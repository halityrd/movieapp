class CategoryModel {
  final int id;
  final String name;

  const CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: (json['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
