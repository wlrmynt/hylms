import 'package:flutter/material.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sertifikat & Pencapaian'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Sertifikat Kursus',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.card_giftcard, size: 48, color: Colors.amber),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Pemrograman Dasar', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Diselesaikan pada 10 November 2023'),
                        Text('Nilai: 85/100'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Download certificate
                    },
                    child: const Text('Download'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Lencana Pencapaian',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildBadge('Pemula', Colors.blue, Icons.star),
              _buildBadge('Lanjutan', Colors.green, Icons.star_border),
              _buildBadge('Expert', Colors.orange, Icons.grade),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String title, Color color, IconData icon) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}