import 'package:flutter/material.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({super.key});

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final _classNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subjectController = TextEditingController();
  String _selectedSemester = '2023/2024 Ganjil';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Kelas Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Kelas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _classNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Kelas',
                border: OutlineInputBorder(),
                hintText: 'Contoh: Pemrograman Web A',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Kelas',
                border: OutlineInputBorder(),
                hintText: 'Jelaskan tentang kelas ini...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Mata Kuliah',
                border: OutlineInputBorder(),
                hintText: 'Contoh: Pemrograman Web',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSemester,
              decoration: const InputDecoration(
                labelText: 'Semester',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: '2023/2024 Ganjil', child: Text('2023/2024 Ganjil')),
                DropdownMenuItem(value: '2023/2024 Genap', child: Text('2023/2024 Genap')),
                DropdownMenuItem(value: '2024/2025 Ganjil', child: Text('2024/2025 Ganjil')),
                DropdownMenuItem(value: '2024/2025 Genap', child: Text('2024/2025 Genap')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSemester = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Kode Kelas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Kode kelas akan di-generate otomatis setelah kelas dibuat.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kode ini akan digunakan mahasiswa untuk bergabung ke kelas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createClass,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Buat Kelas'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createClass() {
    setState(() {
      _isLoading = true;
    });

    // Simulate class creation
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Show success dialog with class code
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kelas Berhasil Dibuat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Kode kelas untuk bergabung:'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'ABC123',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bagikan kode ini ke mahasiswa agar mereka dapat bergabung ke kelas.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}