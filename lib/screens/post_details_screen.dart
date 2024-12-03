import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostDetailScreen extends StatelessWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Detail')),
      body: FutureBuilder(
        future: http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId')),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching post details.'));
          } else {
            final data = json.decode(snapshot.data!.body);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(data['body']),
            );
          }
        },
      ),
    );
  }
}