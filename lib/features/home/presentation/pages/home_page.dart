import 'package:flutter/material.dart';
import 'package:movieapp/features/home/presentation/widgets/movie_slider.dart';
import 'package:movieapp/features/home/presentation/widgets/category_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Sinema'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            MovieSlider(), // üstte slider
            SizedBox(height: 16),
            CategoryList(), // altında kategoriler
          ],
        ),
      ),
    );
  }
}
