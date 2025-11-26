import 'package:flutter/material.dart';

class KursusMandiriScreen extends StatefulWidget {
  const KursusMandiriScreen({super.key});

  @override
  State<KursusMandiriScreen> createState() => _KursusMandiriScreenState();
}

class _KursusMandiriScreenState extends State<KursusMandiriScreen> {
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';

  final List<Map<String, String>> _courses = [
    {'title': 'Pemrograman Dasar', 'category': 'Pemrograman', 'difficulty': 'Beginner', 'duration': '10 jam'},
    {'title': 'Jaringan Komputer', 'category': 'Jaringan', 'difficulty': 'Intermediate', 'duration': '15 jam'},
    {'title': 'Machine Learning', 'category': 'AI', 'difficulty': 'Advanced', 'duration': '20 jam'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kursus Mandiri'),
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('Semua')),
                      DropdownMenuItem(value: 'Pemrograman', child: Text('Pemrograman')),
                      DropdownMenuItem(value: 'Jaringan', child: Text('Jaringan')),
                      DropdownMenuItem(value: 'AI', child: Text('AI')),
                    ],
                    onChanged: (value) => setState(() => _selectedCategory = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDifficulty,
                    decoration: const InputDecoration(labelText: 'Tingkat'),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('Semua')),
                      DropdownMenuItem(value: 'Beginner', child: Text('Pemula')),
                      DropdownMenuItem(value: 'Intermediate', child: Text('Menengah')),
                      DropdownMenuItem(value: 'Advanced', child: Text('Lanjutan')),
                    ],
                    onChanged: (value) => setState(() => _selectedDifficulty = value!),
                  ),
                ),
              ],
            ),
          ),
          // Course List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCourses.length,
              itemBuilder: (context, index) {
                final course = _filteredCourses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(course['title']!),
                    subtitle: Text('${course['category']} • ${course['difficulty']} • ${course['duration']}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to course detail
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> get _filteredCourses {
    return _courses.where((course) {
      final categoryMatch = _selectedCategory == 'All' || course['category'] == _selectedCategory;
      final difficultyMatch = _selectedDifficulty == 'All' || course['difficulty'] == _selectedDifficulty;
      return categoryMatch && difficultyMatch;
    }).toList();
  }
}