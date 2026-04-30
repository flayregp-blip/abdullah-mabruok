enum ReelPageType {
  home,
  following,
  post,
  user,
  hashtag,
  saved,
  notification,
  search,
  audio,
  location,
  single;

  String withId({num? userId = -1, String? hashTag = ''}) {
    switch (this) {
      case ReelPageType.home:
        return 'home';
      case ReelPageType.user:
        return '$userId';
      case ReelPageType.hashtag:
        return hashTag ?? '';
      case ReelPageType.saved:
        return 'saved';
      case ReelPageType.notification:
        return 'notification';
      case ReelPageType.search:
        return 'search';
      case ReelPageType.following:
        return 'following';
      case ReelPageType.single:
        return 'signal';
      case ReelPageType.post:
        return 'post';
      case ReelPageType.audio:
        return 'audio';
      case ReelPageType.location:
        return hashTag ?? '';
    }
  }

  bool get shouldShowBackButton {
    if (this case (ReelPageType.home)) {
      return false;
    }
    return true;
  }

  bool get shouldShowComment {
    if (this case (ReelPageType.home)) {
      return false;
    }
    return true;
  }
}
