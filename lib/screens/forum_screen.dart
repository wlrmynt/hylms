import 'package:flutter/material.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Diskusi'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Diskusi: Algoritma Sorting'),
            subtitle: Text('Dari: Ahmad • 5 balasan'),
            trailing: Icon(Icons.chat),
          ),
          ListTile(
            title: Text('Pertanyaan: Database Normalization'),
            subtitle: Text('Dari: Siti • 3 balasan'),
            trailing: Icon(Icons.chat),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Start new thread
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}