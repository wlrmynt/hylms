import 'package:flutter/material.dart';

class AssignmentSubmissionScreen extends StatefulWidget {
  const AssignmentSubmissionScreen({super.key});

  @override
  State<AssignmentSubmissionScreen> createState() => _AssignmentSubmissionScreenState();
}

class _AssignmentSubmissionScreenState extends State<AssignmentSubmissionScreen> {
  final _answerController = TextEditingController();
  String? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kumpulkan Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tugas 1: Algoritma',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Deadline: 15 November 2023'),
            const SizedBox(height: 16),
            const Text('Deskripsi: Buatlah algoritma untuk sorting array.'),
            const SizedBox(height: 24),
            TextField(
              controller: _answerController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Jawaban Teks (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(_selectedFile ?? 'Tidak ada file dipilih'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Pick file
                    setState(() {
                      _selectedFile = 'tugas1.pdf';
                    });
                  },
                  child: const Text('Pilih File'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Submit
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tugas berhasil dikumpulkan')),
                );
                Navigator.pop(context);
              },
              child: const Text('Kumpulkan'),
            ),
          ],
        ),
      ),
    );
  }
}