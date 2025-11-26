import 'package:flutter/material.dart';
import 'tugas/quiz_screen.dart';

class TugasScreen extends StatelessWidget {
  const TugasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas & Evaluasi'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Tugas 1: Algoritma'),
            subtitle: Text('Deadline: 15 Nov 2023 • Status: Belum dikumpulkan'),
            trailing: Icon(Icons.upload_file),
          ),
          const ListTile(
            title: Text('Tugas 2: Database Design'),
            subtitle: Text('Deadline: 20 Nov 2023 • Status: Dikumpulkan'),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
          ListTile(
            title: const Text('Kuis: Pemrograman Web'),
            subtitle: const Text('Status: Belum dikerjakan'),
            trailing: const Icon(Icons.quiz),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuizScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create assignment if dosen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}