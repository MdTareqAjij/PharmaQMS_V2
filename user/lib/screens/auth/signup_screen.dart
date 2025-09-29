import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String? _error;

  void doSignup() async {
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text.trim(), password: _pass.text);
      // Optionally create user profile in Firestore
      Navigator.pushReplacementNamed(context, '/profile');
    } catch (e) {
      setState(()=> _error = 'Signup failed: \$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create account')),
      body: Padding(padding: EdgeInsets.all(12), child: Column(children:[
        TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
        TextField(controller: _pass, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
        SizedBox(height:12),
        ElevatedButton(onPressed: doSignup, child: Text('Create Account')),
        if (_error!=null) Padding(padding: EdgeInsets.only(top:8), child: Text(_error!, style: TextStyle(color: Colors.red))),
      ])),
    );
  }
}
