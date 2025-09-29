import 'package:flutter/material.dart';
import '../models/post.dart';

class BookmarkService extends ChangeNotifier {
  final List<Post> _bookmarks = [];

  List<Post> get bookmarks => List.unmodifiable(_bookmarks);

  void toggleBookmark(Post p) {
    if (_bookmarks.any((x) => x.id == p.id)) {
      _bookmarks.removeWhere((x) => x.id == p.id);
    } else {
      _bookmarks.add(p);
    }
    notifyListeners();
  }

  bool isBookmarked(Post p) => _bookmarks.any((x) => x.id == p.id);
}
