import 'package:flutter/material.dart';

class MaterialViewScreen extends StatelessWidget {
  const MaterialViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengenalan Pemrograman'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Video player placeholder
            Container(
              height: 200,
              color: Colors.black,
              child: const Center(
                child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi Materi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Materi ini menjelaskan apa itu pemrograman, sejarahnya, dan mengapa penting untuk dipelajari.',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Bookmark
                  },
                  icon: const Icon(Icons.bookmark),
                  label: const Text('Bookmark'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Download
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Next material
              },
              child: const Text('Materi Selanjutnya'),
            ),
          ],
        ),
      ),
    );
  }
}