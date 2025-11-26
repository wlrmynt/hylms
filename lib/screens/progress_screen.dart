import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress & Penilaian'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Kursus',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildProgressCard('Pemrograman Dasar', 0.75),
            _buildProgressCard('Jaringan Komputer', 0.5),
            _buildProgressCard('Machine Learning', 0.2),
            const SizedBox(height: 24),
            const Text(
              'Nilai Rata-rata',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGradeCard('Pemrograman Web', '85'),
                _buildGradeCard('Basis Data', '90'),
                _buildGradeCard('Algoritma', '78'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Sertifikat',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.card_giftcard, color: Colors.amber),
                title: const Text('Sertifikat Pemrograman Dasar'),
                subtitle: const Text('Diselesaikan pada 10 Nov 2023'),
                trailing: const Icon(Icons.download),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(String course, double progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 4),
            Text('${(progress * 100).toInt()}% selesai'),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeCard(String subject, String grade) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              grade,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(subject, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}