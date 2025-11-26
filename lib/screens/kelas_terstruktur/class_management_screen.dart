import 'package:flutter/material.dart';

class ClassManagementScreen extends StatelessWidget {
  final String? className;
  final String? classCode;
  const ClassManagementScreen({super.key, this.className, this.classCode});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(className ?? 'Pemrograman Web'),
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Anggota'),
              Tab(text: 'Materi'),
              Tab(text: 'Pengumuman'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MembersTab(classCode: classCode),
            MaterialsTab(classCode: classCode),
            AnnouncementsTab(classCode: classCode),
          ],
        ),
      ),
    );
  }
}

class MembersTab extends StatelessWidget {
  final String? classCode;
  const MembersTab({super.key, this.classCode});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: CircleAvatar(child: Text('A')),
          title: Text('Ahmad (Dosen)'),
          subtitle: Text('ahmad@univ.edu'),
        ),
        ListTile(
          leading: CircleAvatar(child: Text('S')),
          title: Text('Siti (Mahasiswa)'),
          subtitle: Text('siti@student.edu'),
        ),
        ListTile(
          leading: CircleAvatar(child: Text('B')),
          title: Text('Budi (Mahasiswa)'),
          subtitle: Text('budi@student.edu'),
        ),
      ],
    );
  }
}

class MaterialsTab extends StatelessWidget {
  final String? classCode;
  const MaterialsTab({super.key, this.classCode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: const [
              ListTile(
                leading: Icon(Icons.video_file, color: Colors.blue),
                title: Text('Video: HTML Basics'),
                subtitle: Text('Uploaded 2 days ago'),
                trailing: Icon(Icons.download),
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text('Slides: CSS Introduction'),
                subtitle: Text('Uploaded 1 week ago'),
                trailing: Icon(Icons.download),
              ),
              ListTile(
                leading: Icon(Icons.quiz, color: Colors.green),
                title: Text('Kuis: JavaScript Fundamentals'),
                subtitle: Text('Uploaded 3 days ago'),
                trailing: Icon(Icons.play_arrow),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Upload materi berhasil')),
              );
            },
            icon: const Icon(Icons.upload),
            label: const Text('Upload Materi'),
          ),
        ),
      ],
    );
  }
}

class AnnouncementsTab extends StatelessWidget {
  final String? classCode;
  const AnnouncementsTab({super.key, this.classCode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: const [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pengumuman: Ujian Tengah Semester', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Ujian akan dilaksanakan pada tanggal 20 November 2023.'),
                      SizedBox(height: 8),
                      Text('Dr. Ahmad • 5 Nov 2023', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reminder: Tugas 2', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Deadline tugas 2 diperpanjang hingga 25 November 2023.'),
                      SizedBox(height: 8),
                      Text('Dr. Ahmad • 3 Nov 2023', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pengumuman berhasil ditambahkan')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Pengumuman'),
          ),
        ),
      ],
    );
  }
}