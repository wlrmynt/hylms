import 'package:flutter/material.dart';
import 'kelas_terstruktur/create_class_screen.dart';

class KelasTerstrukturScreen extends StatelessWidget {
  const KelasTerstrukturScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelas Terstruktur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateClassScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Masukkan Kode Kelas',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (code) {
                // Join class logic
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  title: Text('Pemrograman Web'),
                  subtitle: Text('Dosen: Dr. Ahmad • Semester: 3'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  title: Text('Basis Data'),
                  subtitle: Text('Dosen: Prof. Siti • Semester: 4'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}