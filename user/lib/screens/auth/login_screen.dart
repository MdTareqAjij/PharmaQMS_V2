import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String? _error;

  void doLogin() async {
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text.trim(), password: _pass.text);
      Navigator.pushReplacementNamed(context, '/profile');
    } catch (e) {
      setState(()=> _error = 'Login failed: \$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _pass, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height:12),
            ElevatedButton(onPressed: doLogin, child: Text('Login')),
            TextButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> SignupScreen())), child: Text('Create new account')),
            if (_error!=null) Padding(padding: EdgeInsets.only(top:8), child: Text(_error!, style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }
}
