import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/features/home/providers/movie_provider.dart';

class MovieSlider extends ConsumerStatefulWidget {
  const MovieSlider({super.key});

  @override
  ConsumerState<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends ConsumerState<MovieSlider> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  // Yardımcı: TMDB path normalize
  String _normalizePath(String value) {
    if (value.isEmpty) return '';
    return value.startsWith('/') ? value : '/$value';
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(movieViewModelProvider);

    return moviesAsync.when(
      data: (movies) {
        if (movies.isEmpty) return const SizedBox.shrink();

        // Maksimum 5 film göster
        final int count = math.min(movies.length, 5);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CarouselSlider.builder(
              carouselController: _controller,
              itemCount: count,
              options: CarouselOptions(
                height: 220,
                viewportFraction: 0.85,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayCurve: Curves.easeInOut,
                onPageChanged: (index, reason) {
                  setState(() => _current = index);

                  // Basit prefetch: bir sonraki görseli önceden ısıt
                  final nextIndex = (index + 1) % count;
                  final nextPoster = _normalizePath(
                    movies[nextIndex].posterPath,
                  );
                  if (nextPoster.isNotEmpty) {
                    final nextUrl =
                        'https://image.tmdb.org/t/p/w500$nextPoster';
                    precacheImage(CachedNetworkImageProvider(nextUrl), context);
                  }
                },
              ),
              itemBuilder: (context, index, realIndex) {
                final movie = movies[index];
                final posterPath = _normalizePath(movie.posterPath);
                final backdropPath = _normalizePath(movie.backdropPath);
                final posterUrl = posterPath.isNotEmpty
                    ? 'https://image.tmdb.org/t/p/w500$posterPath'
                    : '';
                final fallbackUrl = backdropPath.isNotEmpty
                    ? 'https://image.tmdb.org/t/p/w500$backdropPath'
                    : '';

                return GestureDetector(
                  onTap: () {
                    debugPrint('Tapped movie: ${movie.id} — ${movie.title}');
                  },
                  child: Hero(
                    tag: 'movie_${movie.id}_poster',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (posterUrl.isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: posterUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[850]),
                              errorWidget: (context, url, error) {
                                if (fallbackUrl.isNotEmpty) {
                                  return CachedNetworkImage(
                                    imageUrl: fallbackUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(color: Colors.grey[850]),
                                    errorWidget: (context, url, error) =>
                                        const _ImageErrorFallback(),
                                  );
                                }
                                return const _ImageErrorFallback();
                              },
                            )
                          else if (fallbackUrl.isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: fallbackUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[850]),
                              errorWidget: (context, url, error) =>
                                  const _ImageErrorFallback(),
                            )
                          else
                            const _ImageErrorFallback(),

                          // Gradient + başlık
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(
                                10,
                                24,
                                10,
                                10,
                              ),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black87],
                                ),
                              ),
                              child: Text(
                                movie.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            // Dot indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(count, (i) {
                final isActive = i == _current;
                return GestureDetector(
                  onTap: () => _controller.animateToPage(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    width: isActive ? 18 : 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) {
        debugPrint('MovieSlider error: $err');
        return SizedBox(height: 220, child: Center(child: Text('Hata: $err')));
      },
    );
  }
}

class _ImageErrorFallback extends StatelessWidget {
  const _ImageErrorFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, color: Colors.white70),
    );
  }
}
