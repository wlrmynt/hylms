import 'package:flutter/material.dart';
import 'tugas/quiz_screen.dart';
import 'tugas/assignment_submission_screen.dart';

class TugasScreen extends StatefulWidget {
  const TugasScreen({super.key});

  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Semua';

  final List<Map<String, dynamic>> _assignments = [
    {
      'title': 'Tugas 1: Algoritma',
      'course': 'Algoritma dan Struktur Data',
      'type': 'Tugas',
      'dueDate': '2024-12-15',
      'status': 'Belum dikumpulkan',
      'points': 100,
      'color': const Color(0xFFFF5722),
      'icon': Icons.assignment,
      'description': 'Implementasi algoritma sorting dan searching',
    },
    {
      'title': 'Tugas 2: Database Design',
      'course': 'Basis Data',
      'type': 'Tugas',
      'dueDate': '2024-12-20',
      'status': 'Dikumpulkan',
      'points': 100,
      'color': const Color(0xFF4CAF50),
      'icon': Icons.storage,
      'description': 'Merancang skema database untuk aplikasi e-commerce',
    },
    {
      'title': 'UTS: Pemrograman Web',
      'course': 'Pemrograman Web',
      'type': 'Ujian',
      'dueDate': '2024-12-18',
      'status': 'Scheduled',
      'points': 150,
      'color': const Color(0xFF2196F3),
      'icon': Icons.quiz,
      'description': 'Ujian tengah semester pemrograman web',
    },
    {
      'title': 'Proyek Akhir: Mobile App',
      'course': 'Mobile Development',
      'type': 'Proyek',
      'dueDate': '2024-12-30',
      'status': 'Berlangsung',
      'points': 200,
      'color': const Color(0xFF9C27B0),
      'icon': Icons.phone_android,
      'description': 'Membangun aplikasi mobile dengan Flutter',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF9800),
              Color(0xFFFF5722),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tugas & Evaluasi',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kelola tugas dan evaluasi Anda',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.white,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  tabs: const [
                    Tab(text: 'Aktif'),
                    Tab(text: 'Dikumpulkan'),
                    Tab(text: 'Ujian'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Filter Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedFilter,
                          decoration: const InputDecoration(
                            labelText: 'Filter Mata Kuliah',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                            DropdownMenuItem(value: 'Algoritma', child: Text('Algoritma')),
                            DropdownMenuItem(value: 'Basis Data', child: Text('Basis Data')),
                            DropdownMenuItem(value: 'Pemrograman Web', child: Text('Pemrograman Web')),
                            DropdownMenuItem(value: 'Mobile Development', child: Text('Mobile Dev')),
                          ],
                          onChanged: (value) => setState(() => _selectedFilter = value!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Task List
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
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildAssignmentList('active'),
                        _buildAssignmentList('submitted'),
                        _buildAssignmentList('exam'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur pembuatan tugas untuk dosen')),
          );
        },
        backgroundColor: const Color(0xFFFF9800),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAssignmentList(String filter) {
    List<Map<String, dynamic>> filteredAssignments = _assignments.where((assignment) {
      if (filter == 'active' && assignment['status'] == 'Belum dikumpulkan') return true;
      if (filter == 'submitted' && assignment['status'] == 'Dikumpulkan') return true;
      if (filter == 'exam' && assignment['type'] == 'Ujian') return true;
      return false;
    }).toList();

    if (_selectedFilter != 'Semua') {
      filteredAssignments = filteredAssignments.where((assignment) {
        return assignment['course'].toLowerCase().contains(_selectedFilter.toLowerCase());
      }).toList();
    }

    if (filteredAssignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada tugas',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredAssignments.length,
      itemBuilder: (context, index) {
        final assignment = filteredAssignments[index];
        return _buildAssignmentCard(assignment, context);
      },
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment, BuildContext context) {
    final bool isCompleted = assignment['status'] == 'Dikumpulkan';
    final bool isQuiz = assignment['type'] == 'Ujian';
    final bool isOverdue = DateTime.parse(assignment['dueDate']).isBefore(DateTime.now()) && !isCompleted;

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
        border: Border.all(
          color: isOverdue 
              ? const Color(0xFFFF5722).withOpacity(0.3)
              : assignment['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (isQuiz) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuizScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AssignmentSubmissionScreen(),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          assignment['color'],
                          assignment['color'].withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      assignment['icon'],
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                assignment['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isCompleted 
                                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                                    : isOverdue
                                        ? const Color(0xFFFF5722).withOpacity(0.1)
                                        : assignment['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                assignment['status'],
                                style: TextStyle(
                                  color: isCompleted 
                                      ? const Color(0xFF4CAF50)
                                      : isOverdue
                                          ? const Color(0xFFFF5722)
                                          : assignment['color'],
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assignment['course'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: isOverdue ? const Color(0xFFFF5722) : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(assignment['dueDate']),
                              style: TextStyle(
                                color: isOverdue ? const Color(0xFFFF5722) : Colors.grey[600],
                                fontSize: 12,
                                fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${assignment['points']} poin',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.arrow_forward_ios,
                    color: isCompleted ? const Color(0xFF4CAF50) : Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  assignment['description'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == 1) {
      return 'Besok';
    } else if (difference > 0) {
      return '$difference hari lagi';
    } else {
      return '${-difference} hari terlambat';
    }
  }
}