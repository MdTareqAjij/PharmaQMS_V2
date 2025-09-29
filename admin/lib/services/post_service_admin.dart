import 'package:cloud_firestore/cloud_firestore.dart';

class PostServiceAdmin {
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');

  Future<void> createPost(String title, String content) async {
    await posts.add({
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
