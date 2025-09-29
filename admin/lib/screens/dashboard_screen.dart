import 'package:flutter/material.dart';
import 'create_content.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> Navigator.pushNamed(context, '/create'),
        child: Icon(Icons.add),
        tooltip: 'Create New Content',
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Text('Active Users: (fetch from Firestore)'),
          SizedBox(height:8),
          Text('Total Posts: (fetch count)'),
          SizedBox(height:8),
          Text('Top Posts by Views:'),
          ListTile(title: Text('How to write SOP'), trailing: Text('1.2k views')),
          ListTile(title: Text('GMP Basics'), trailing: Text('980 views')),
          SizedBox(height:12),
          Text('Note: Hook these numbers to Firestore aggregations or Cloud Functions for real analytics.')
        ],
      ),
    );
  }
}
