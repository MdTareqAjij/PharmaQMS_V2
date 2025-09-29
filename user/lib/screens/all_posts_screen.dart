import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import 'post_detail.dart';

class AllPostsScreen extends StatefulWidget {
  @override
  State<AllPostsScreen> createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  final PostService _service = PostService();
  List<Post> posts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      posts = await _service.allPosts();
    } catch (e) {
      posts = [];
    }
    setState(()=> loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Posts')),
      body: loading ? Center(child: CircularProgressIndicator()) : ListView(children: posts.map((p)=>ListTile(title: Text(p.title), subtitle: Text(p.category), onTap: ()=> Navigator.pushNamed(context, '/post', arguments: p))).toList()),
    );
  }
}
