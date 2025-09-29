import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import 'post_detail.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  CategoryScreen({required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
      posts = await _service.postsByCategory(widget.category);
    } catch (e) {
      posts = [];
    }
    setState(()=> loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: loading ? Center(child: CircularProgressIndicator()) : ListView(
        children: posts.map((p) => ListTile(title: Text(p.title), subtitle: Text(p.createdAt.toLocal().toString().split(' ')[0]), onTap: ()=> Navigator.pushNamed(context, PostDetail.routeName, arguments: p))).toList(),
      ),
    );
  }
}
