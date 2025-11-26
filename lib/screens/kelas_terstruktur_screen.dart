import 'package:flutter/material.dart';
import 'kelas_terstruktur/create_class_screen.dart';
import 'kelas_terstruktur/class_management_screen.dart';

class KelasTerstrukturScreen extends StatefulWidget {
  const KelasTerstrukturScreen({super.key});

  @override
  State<KelasTerstrukturScreen> createState() => _KelasTerstrukturScreenState();
}

class _KelasTerstrukturScreenState extends State<KelasTerstrukturScreen> {
  final TextEditingController _codeController = TextEditingController();
  final List<Map<String, dynamic>> _classes = [
    {
      'name': 'Pemrograman Web',
      'code': 'PW2024',
      'instructor': 'Dr. Ahmad',
      'semester': 3,
      'students': 45,
      'status': 'Aktif',
      'color': const Color(0xFF6C63FF),
      'icon': Icons.web,
    },
    {
      'name': 'Basis Data',
      'code': 'DB2024',
      'instructor': 'Prof. Siti',
      'semester': 4,
      'students': 38,
      'status': 'Aktif',
      'color': const Color(0xFF4CAF50),
      'icon': Icons.storage,
    },
    {
      'name': 'Algoritma dan Struktur Data',
      'code': 'ASD2024',
      'instructor': 'Dr. Budi',
      'semester': 2,
      'students': 52,
      'status': 'Berakhir',
      'color': const Color(0xFFFF5722),
      'icon': Icons.architecture,
    },
    {
      'name': 'Jaringan Komputer',
      'code': 'JK2024',
      'instructor': 'Prof. Maya',
      'semester': 5,
      'students': 31,
      'status': 'Aktif',
      'color': const Color(0xFF2196F3),
      'icon': Icons.network_check,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF8BC34A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kelas Terstruktur',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Bergabung dengan kelas yang diajar dosen',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white, size: 28),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateClassScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Join Class Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bergabung dengan Kelas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _codeController,
                              decoration: const InputDecoration(
                                hintText: 'Masukkan kode kelas...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: _joinClass,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Class List
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _classes.length,
                      itemBuilder: (context, index) {
                        final classData = _classes[index];
                        return _buildClassCard(classData, context);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classData, BuildContext context) {
    final bool isActive = classData['status'] == 'Aktif';
    final Color cardColor = isActive ? Colors.white : Colors.grey[50]!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isActive ? classData['color'].withOpacity(0.2) : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassManagementScreen(
                className: classData['name'],
                classCode: classData['code'],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Class Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      classData['color'],
                      classData['color'].withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  classData['icon'],
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              // Class Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          classData['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isActive 
                                ? const Color(0xFF4CAF50).withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            classData['status'],
                            style: TextStyle(
                              color: isActive 
                                  ? const Color(0xFF4CAF50)
                                  : Colors.grey[600],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${classData['instructor']} • Semester ${classData['semester']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${classData['students']} mahasiswa',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: classData['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            classData['code'],
                            style: TextStyle(
                              color: classData['color'],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _joinClass() {
    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan kode kelas')),
      );
      return;
    }

    // Simulate joining class
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Berhasil bergabung dengan kelas!')),
    );
    _codeController.clear();
  }
}