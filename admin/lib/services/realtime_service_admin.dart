import 'package:firebase_database/firebase_database.dart';

class RealtimeServiceAdmin {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("posts");

  Future<void> createPost(String title, String content) async {
    await dbRef.push().set({
      'title': title,
      'content': content,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
