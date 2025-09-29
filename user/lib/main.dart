import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/post_detail.dart';
import 'screens/search_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile_screen.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'services/bookmark_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(PharmaQMSUserApp());
}

class PharmaQMSUserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookmarkService(),
      child: MaterialApp(
        title: 'Pharma QMS',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (_) => HomeScreen(),
          '/search': (_) => SearchScreen(),
          '/login': (_) => LoginScreen(),
          '/profile': (_) => ProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == PostDetail.routeName) {
            final post = settings.arguments;
            return MaterialPageRoute(builder: (_) => PostDetail(post: post));
          }
          return null;
        },
      ),
    );
  }
}
