import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import 'category_screen.dart';
import 'all_posts_screen.dart';
import '../services/bookmark_service.dart';
import 'package:provider/provider.dart';
import 'post_detail.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _service = PostService();
  List<Post> recent = [];
  List<String> categories = [
    'Quality Control','Quality Assurance','Production','Warehouse','R&D','PMD',
    'Regulatory Affairs','Validation','Guidelines','SOP','STP','Job Preparation',
    'Job Circular','Training','IMD',"Drug's & Medicine",'Microbiology','Marketing'
  ];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      recent = await _service.recentPosts(limit: 8);
    } catch (e) {
      // In case Firestore isn't configured yet, fallback to empty list
      recent = [];
    }
    setState(()=> loading = false);
  }

  String excerpt(String html, [int len=120]) {
    final text = html.replaceAll(RegExp(r'<[^>]*>'), '');
    if (text.length <= len) return text;
    return text.substring(0, len) + '...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharma QMS'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () => Navigator.pushNamed(context, '/search')),
          IconButton(icon: Icon(Icons.person), onPressed: () => Navigator.pushNamed(context, '/login')),
        ],
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : ListView(
        padding: EdgeInsets.all(12),
        children: [
          Text('Recent Posts', style: Theme.of(context).textTheme.headline6),
          ...recent.map((p) => Card(
            child: ListTile(
              title: Text(p.title),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.category + ' • ' + p.createdAt.toLocal().toString().split(' ')[0]),
                SizedBox(height:4),
                Text(excerpt(p.contentHtml)),
                TextButton(onPressed: ()=> Navigator.pushNamed(context, PostDetail.routeName, arguments: p), child: Text('Read more'))
              ]),
              trailing: IconButton(
                icon: Icon(Provider.of<BookmarkService>(context).isBookmarked(p) ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () => Provider.of<BookmarkService>(context, listen:false).toggleBookmark(p),
              ),
            ),
          )),
          SizedBox(height:12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories', style: Theme.of(context).textTheme.headline6),
              TextButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => AllCategoriesScreen())), child: Text('All Category'))
            ],
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(4, (i){
              final cat = categories[i];
              return Card(
                child: InkWell(
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(category: cat))),
                  child: Center(child: Padding(padding: EdgeInsets.all(8), child: Text(cat, textAlign: TextAlign.center))),
                ),
              );
            }),
          ),
          SizedBox(height: 12),
          TextButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => AllPostsScreen())), child: Text('All Posts'))
        ],
      ),
    );
  }
}

class AllCategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = [
      'Quality Control','Quality Assurance','Production','Warehouse','R&D','PMD',
      'Regulatory Affairs','Validation','Guidelines','SOP','STP','Job Preparation',
      'Job Circular','Training','IMD',"Drug's & Medicine",'Microbiology','Marketing'
    ];
    return Scaffold(
      appBar: AppBar(title: Text('All Categories')),
      body: ListView(children: categories.map((c)=>ListTile(title: Text(c), onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>CategoryScreen(category: c))))).toList()),
    );
  }
}
