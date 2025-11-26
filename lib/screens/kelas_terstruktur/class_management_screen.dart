import 'package:flutter/material.dart';

class ClassManagementScreen extends StatelessWidget {
  const ClassManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pemrograman Web'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Anggota'),
              Tab(text: 'Materi'),
              Tab(text: 'Pengumuman'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MembersTab(),
            MaterialsTab(),
            AnnouncementsTab(),
          ],
        ),
      ),
    );
  }
}

class MembersTab extends StatelessWidget {
  const MembersTab({super.key});

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
      ],
    );
  }
}

class MaterialsTab extends StatelessWidget {
  const MaterialsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: const [
              ListTile(
                leading: Icon(Icons.video_file),
                title: Text('Video: HTML Basics'),
                subtitle: Text('Uploaded 2 days ago'),
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text('Slides: CSS Introduction'),
                subtitle: Text('Uploaded 1 week ago'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              // Upload material
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
  const AnnouncementsTab({super.key});

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
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              // Add announcement
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Pengumuman'),
          ),
        ),
      ],
    );
  }
}