import 'package:flutter/material.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemrograman Dasar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deskripsi Kursus',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pelajari dasar-dasar pemrograman dengan bahasa yang mudah dipahami. Kursus ini mencakup konsep dasar, algoritma, dan praktik coding.',
            ),
            const SizedBox(height: 16),
            const Text('Instruktur: Dr. Ahmad'),
            const Text('Durasi: 10 jam'),
            const SizedBox(height: 16),
            const Text('Progres: 75%'),
            LinearProgressIndicator(value: 0.75),
            const SizedBox(height: 24),
            const Text(
              'Daftar Materi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildModuleCard('1. Pengenalan Pemrograman', 'Video - 30 menit', Icons.play_arrow),
            _buildModuleCard('2. Variabel dan Tipe Data', 'PDF - 15 halaman', Icons.picture_as_pdf),
            _buildModuleCard('3. Kuis Bab 1', 'Quiz - 10 soal', Icons.quiz),
            _buildModuleCard('4. Struktur Kontrol', 'Video - 45 menit', Icons.play_arrow),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Take final test
              },
              child: const Text('Evaluasi Akhir'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(String title, String subtitle, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to material view
        },
      ),
    );
  }
}