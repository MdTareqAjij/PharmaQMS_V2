import 'package:firebase_database/firebase_database.dart';

class RealtimeServiceUser {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("posts");

  Stream<DatabaseEvent> getPosts() {
    return dbRef.onValue;
  }
}
