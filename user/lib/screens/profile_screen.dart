import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ' + (user?.displayName ?? '')),
            SizedBox(height:8),
            Text('Email: ' + (user?.email ?? '')),
            SizedBox(height:16),
            ElevatedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit profile - TODO'))), child: Text('Edit Profile')),
            SizedBox(height:16),
            ElevatedButton(onPressed: () async { await FirebaseAuth.instance.signOut(); Navigator.pushReplacementNamed(context, '/'); }, child: Text('Logout')),
          ],
        ),
      ),
    );
  }
}
