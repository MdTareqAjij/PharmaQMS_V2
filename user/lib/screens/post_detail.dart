import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class PostDetail extends StatefulWidget {
  static const routeName = '/post';
  final Post post;
  PostDetail({required this.post});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final PostService _service = PostService();

  @override
  void initState() {
    super.initState();
    // increment view counter (best-effort)
    try { _service.incrementView(widget.post.id); } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    return Scaffold(
      appBar: AppBar(title: Text(p.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (p.imageUrl != null) Image.network(p.imageUrl!),
            SizedBox(height:8),
            Html(data: p.contentHtml),
            SizedBox(height:12),
            if (p.driveLink != null && p.driveLink!.isNotEmpty)
              TextButton.icon(icon: Icon(Icons.drive_file_move), label: Text('Open Drive Link'), onPressed: () {/* open link using url_launcher - TODO */}),
          ],
        ),
      ),
    );
  }
}
