import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Popüler',
      'Vizyondakiler',
      'Yakında',
      'En Çok Oy Alanlar',
    ];

    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Chip(
            label: Text(category, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.grey[800],
          );
        },
      ),
    );
  }
}
