import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

class PostService {
  final _col = FirebaseFirestore.instance.collection('posts');

  Future<List<Post>> recentPosts({int limit = 10}) async {
    final snap = await _col.orderBy('createdAt', descending: true).limit(limit).get();
    return snap.docs.map((d) => Post(
      id: d.id,
      title: d['title'] ?? '',
      contentHtml: d['contentHtml'] ?? '',
      category: d['category'] ?? '',
      imageUrl: d['imageUrl'],
      driveLink: d['driveLink'],
      createdAt: (d['createdAt'] as Timestamp).toDate(),
      views: d['views'] ?? 0,
    )).toList();
  }

  Future<List<Post>> postsByCategory(String category) async {
    final snap = await _col.where('category', isEqualTo: category).orderBy('createdAt', descending: true).get();
    return snap.docs.map((d) => Post.fromMap(d.id, d.data() as Map<String, dynamic>)).toList();
  }

  Future<List<Post>> allPosts() async {
    final snap = await _col.orderBy('createdAt', descending: true).get();
    return snap.docs.map((d) => Post.fromMap(d.id, d.data() as Map<String, dynamic>)).toList();
  }

  Future<void> incrementView(String postId) async {
    await _col.doc(postId).update({'views': FieldValue.increment(1)});
  }
}
