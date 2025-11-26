import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.class_, color: Colors.blue),
            title: Text('Kelas Baru'),
            subtitle: Text('Anda telah bergabung ke kelas Pemrograman Web'),
            trailing: Text('2h ago'),
          ),
          ListTile(
            leading: Icon(Icons.assignment, color: Colors.orange),
            title: Text('Tugas Baru'),
            subtitle: Text('Deadline tugas Algoritma: 15 Nov'),
            trailing: Text('1d ago'),
          ),
          ListTile(
            leading: Icon(Icons.forum, color: Colors.green),
            title: Text('Balasan Forum'),
            subtitle: Text('Ahmad membalas diskusi Anda'),
            trailing: Text('3h ago'),
          ),
          ListTile(
            leading: Icon(Icons.announcement, color: Colors.red),
            title: Text('Pengumuman'),
            subtitle: Text('Ujian tengah semester minggu depan'),
            trailing: Text('1w ago'),
          ),
        ],
      ),
    );
  }
}