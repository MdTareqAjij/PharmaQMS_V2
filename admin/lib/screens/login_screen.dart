import 'package:flutter/material.dart';

// For demo only - replace with Firebase Auth rule protected admin.
const ADMIN_EMAIL = 'admin@pharmaqms.com';
const ADMIN_PASS = 'admin@123';

class AdminLoginScreen extends StatefulWidget {
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String? _error;

  void doLogin() {
    if (_email.text.trim() == ADMIN_EMAIL && _pass.text == ADMIN_PASS) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState(()=> _error = 'Invalid credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _pass, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height:12),
            ElevatedButton(onPressed: doLogin, child: Text('Login')),
            if (_error!=null) Padding(padding: EdgeInsets.only(top:8), child: Text(_error!, style: TextStyle(color: Colors.red))),
            SizedBox(height:12),
            Text('Demo admin credentials are in code. Replace with Firebase Auth for production.')
          ],
        ),
      ),
    );
  }
}
