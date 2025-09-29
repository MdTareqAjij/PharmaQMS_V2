import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import 'post_detail.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String q = '';
  List<Post> results = [];
  final PostService _service = PostService();
  bool loading = false;

  void doSearch(String query) async {
    setState(()=> loading = true);
    final all = await _service.allPosts();
    setState(() {
      results = all.where((p) => p.title.toLowerCase().contains(query.toLowerCase()) || p.contentHtml.toLowerCase().contains(query.toLowerCase())).toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(hintText: 'Search posts...'),
              onChanged: (v){ q=v; doSearch(v); },
            ),
          ),
          if (loading) LinearProgressIndicator(),
          Expanded(child: ListView(children: results.map((p)=>ListTile(title: Text(p.title), subtitle: Text(p.category), onTap: ()=> Navigator.pushNamed(context, PostDetail.routeName, arguments: p))).toList()))
        ],
      ),
    );
  }
}
