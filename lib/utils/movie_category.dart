enum MovieCategory {
  popular,
  topRated,
  upcoming,
  nowPlaying;

  String get path {
    switch (this) {
      case MovieCategory.popular:
        return 'popular';
      case MovieCategory.topRated:
        return 'top_rated';
      case MovieCategory.upcoming:
        return 'upcoming';
      case MovieCategory.nowPlaying:
        return 'now_playing';
    }
  }
}
