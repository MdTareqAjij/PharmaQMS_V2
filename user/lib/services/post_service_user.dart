import 'package:cloud_firestore/cloud_firestore.dart';

class PostServiceUser {
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');

  Stream<QuerySnapshot> getPosts() {
    return posts.orderBy('timestamp', descending: true).snapshots();
  }
}
