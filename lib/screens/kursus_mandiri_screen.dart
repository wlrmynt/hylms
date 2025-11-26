import 'package:flutter/material.dart';
import 'kursus_mandiri/course_detail_screen.dart';

class KursusMandiriScreen extends StatefulWidget {
  const KursusMandiriScreen({super.key});

  @override
  State<KursusMandiriScreen> createState() => _KursusMandiriScreenState();
}

class _KursusMandiriScreenState extends State<KursusMandiriScreen> {
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'Pemrograman Dasar',
      'category': 'Pemrograman',
      'difficulty': 'Beginner',
      'duration': '10 jam',
      'students': 1250,
      'rating': 4.8,
      'color': const Color(0xFF6C63FF),
      'icon': Icons.code,
      'image': 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=300&h=200&fit=crop'
    },
    {
      'title': 'Jaringan Komputer',
      'category': 'Jaringan',
      'difficulty': 'Intermediate',
      'duration': '15 jam',
      'students': 890,
      'rating': 4.6,
      'color': const Color(0xFF4CAF50),
      'icon': Icons.network_check,
      'image': 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=300&h=200&fit=crop'
    },
    {
      'title': 'Machine Learning',
      'category': 'AI',
      'difficulty': 'Advanced',
      'duration': '20 jam',
      'students': 567,
      'rating': 4.9,
      'color': const Color(0xFFFF5722),
      'icon': Icons.psychology,
      'image': 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=300&h=200&fit=crop'
    },
    {
      'title': 'Web Development',
      'category': 'Pemrograman',
      'difficulty': 'Intermediate',
      'duration': '18 jam',
      'students': 2100,
      'rating': 4.7,
      'color': const Color(0xFF2196F3),
      'icon': Icons.web,
      'image': 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=300&h=200&fit=crop'
    },
    {
      'title': 'Database Management',
      'category': 'Database',
      'difficulty': 'Beginner',
      'duration': '12 jam',
      'students': 1800,
      'rating': 4.5,
      'color': const Color(0xFF9C27B0),
      'icon': Icons.storage,
      'image': 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=300&h=200&fit=crop'
    },
    {
      'title': 'Mobile App Development',
      'category': 'Pemrograman',
      'difficulty': 'Advanced',
      'duration': '25 jam',
      'students': 945,
      'rating': 4.8,
      'color': const Color(0xFFFF9800),
      'icon': Icons.phone_android,
      'image': 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=300&h=200&fit=crop'
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
              Color(0xFF667eea),
              Color(0xFF764ba2),
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
                    const Text(
                      'Kursus Mandiri',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pelajari skill baru di waktu luang Anda',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Cari kursus...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Filter Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Kategori',
                            labelStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          ),
                          dropdownColor: const Color(0xFF667eea),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white,
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('Semua', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'Pemrograman', child: Text('Pemrograman', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'Jaringan', child: Text('Jaringan', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'AI', child: Text('AI', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'Database', child: Text('Database', style: TextStyle(color: Colors.white))),
                          ],
                          onChanged: (value) => setState(() => _selectedCategory = value!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedDifficulty,
                          decoration: const InputDecoration(
                            labelText: 'Tingkat',
                            labelStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          ),
                          dropdownColor: const Color(0xFF667eea),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white,
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('Semua', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'Beginner', child: Text('Pemula', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'Intermediate', child: Text('Menengah', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'Advanced', child: Text('Lanjutan', style: TextStyle(color: Colors.white))),
                          ],
                          onChanged: (value) => setState(() => _selectedDifficulty = value!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Course List
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
                      itemCount: _filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = _filteredCourses[index];
                        return _buildCourseCard(course, context);
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

  Widget _buildCourseCard(Map<String, dynamic> course, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(courseTitle: course['title']),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Course Image/Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      course['color'],
                      course['color'].withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  course['icon'],
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(width: 16),
              // Course Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course['duration'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.people,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course['students']} siswa',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: course['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            course['difficulty'],
                            style: TextStyle(
                              color: course['color'],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 12, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              course['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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

  List<Map<String, dynamic>> get _filteredCourses {
    return _courses.where((course) {
      final categoryMatch = _selectedCategory == 'All' || course['category'] == _selectedCategory;
      final difficultyMatch = _selectedDifficulty == 'All' || course['difficulty'] == _selectedDifficulty;
      final searchMatch = _searchController.text.isEmpty || 
          course['title'].toLowerCase().contains(_searchController.text.toLowerCase());
      return categoryMatch && difficultyMatch && searchMatch;
    }).toList();
  }
}