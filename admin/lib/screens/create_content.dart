import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class CreateContentScreen extends StatefulWidget {
  @override
  State<CreateContentScreen> createState() => _CreateContentScreenState();
}

class _CreateContentScreenState extends State<CreateContentScreen> {
  final _title = TextEditingController();
  final _driveLink = TextEditingController();
  final List<TextEditingController> _descControllers = [TextEditingController()];
  String? _selectedCategory;
  String? _pickedFilePath;
  final categories = [
    'Quality Control','Quality Assurance','Production','Warehouse','R&D','PMD',
    'Regulatory Affairs','Validation','Guidelines','SOP','STP','Job Preparation',
    'Job Circular','Training','IMD',"Drug's & Medicine",'Microbiology','Marketing'
  ];

  Future<String?> uploadToDrive(String filePath) async {
    try {
      final uri = Uri.parse("http://YOUR_SERVER_IP:3000/upload");
      var request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = jsonDecode(respStr);
        return data["link"];
      }
    } catch (e) {
      print("Drive upload error: $e");
    }
    return null;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedFilePath = picked.path;
      });
    }
  }

  void addDescField() {
    setState(()=> _descControllers.add(TextEditingController()));
  }

  Future<void> submit() async {
    final title = _title.text;
    final contentHtml = _descControllers.map((c)=> '<p>${c.text}</p>').join();
    final category = _selectedCategory;
    String? driveLink;

    if (_pickedFilePath != null) {
      driveLink = await uploadToDrive(_pickedFilePath!);
    } else {
      driveLink = _driveLink.text;
    }

    await FirebaseFirestore.instance.collection("posts").add({
      "title": title,
      "contentHtml": contentHtml,
      "category": category,
      "driveLink": driveLink,
      "createdAt": FieldValue.serverTimestamp(),
      "views": 0,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Post created successfully!"))
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Content')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(controller: _title, decoration: InputDecoration(labelText: 'Title')),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: categories.map((c)=> DropdownMenuItem(child: Text(c), value: c)).toList(),
              onChanged: (v)=> setState(()=> _selectedCategory = v),
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height:8),
            Text('Descriptions'),
            ..._descControllers.map((c)=> Padding(padding: EdgeInsets.only(top:8), child: TextField(controller: c, maxLines: 4, decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'HTML allowed')))),
            SizedBox(height:8),
            TextButton(onPressed: addDescField, child: Text('Add another description field')),
            SizedBox(height:8),
            TextField(controller: _driveLink, decoration: InputDecoration(labelText: 'Google Drive link (optional)')),
            SizedBox(height:8),
            if (_pickedFilePath != null) Text("Picked file: $_pickedFilePath"),
            ElevatedButton(onPressed: pickImage, child: Text("Pick Image for Drive Upload")),
            SizedBox(height:12),
            ElevatedButton(onPressed: submit, child: Text('Create Content')),
            SizedBox(height:8),
            Text('File will upload to Google Drive server if picked, or manual link will be used.'),
          ],
        ),
      ),
    );
  }
}
