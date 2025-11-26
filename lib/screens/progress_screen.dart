import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Semua';

  final List<Map<String, dynamic>> _courses = [
    {
      'name': 'Pemrograman Dasar',
      'progress': 0.75,
      'totalHours': 40,
      'completedHours': 30,
      'color': const Color(0xFF4CAF50),
      'icon': Icons.code,
      'lastActivity': '2024-11-25',
    },
    {
      'name': 'Jaringan Komputer',
      'progress': 0.5,
      'totalHours': 35,
      'completedHours': 18,
      'color': const Color(0xFF2196F3),
      'icon': Icons.network_check,
      'lastActivity': '2024-11-24',
    },
    {
      'name': 'Machine Learning',
      'progress': 0.2,
      'totalHours': 50,
      'completedHours': 10,
      'color': const Color(0xFFFF5722),
      'icon': Icons.psychology,
      'lastActivity': '2024-11-20',
    },
    {
      'name': 'Web Development',
      'progress': 0.85,
      'totalHours': 45,
      'completedHours': 38,
      'color': const Color(0xFF9C27B0),
      'icon': Icons.web,
      'lastActivity': '2024-11-26',
    },
  ];

  final List<Map<String, dynamic>> _grades = [
    {'subject': 'Pemrograman Web', 'grade': '85', 'color': const Color(0xFF4CAF50), 'credits': 3},
    {'subject': 'Basis Data', 'grade': '90', 'color': const Color(0xFF2196F3), 'credits': 4},
    {'subject': 'Algoritma', 'grade': '78', 'color': const Color(0xFFFF9800), 'credits': 3},
    {'subject': 'Struktur Data', 'grade': '82', 'color': const Color(0xFF9C27B0), 'credits': 4},
    {'subject': 'Sistem Operasi', 'grade': '88', 'color': const Color(0xFF607D8B), 'credits': 3},
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'Pemrograman Dasar',
      'date': '10 Nov 2023',
      'score': '85/100',
      'color': const Color(0xFFFFC107),
      'icon': Icons.card_giftcard,
    },
    {
      'title': 'JavaScript Specialist',
      'date': '15 Okt 2023',
      'score': '92/100',
      'color': const Color(0xFF4CAF50),
      'icon': Icons.verified,
    },
    {
      'title': 'Database Expert',
      'date': '5 Sep 2023',
      'score': '88/100',
      'color': const Color(0xFF2196F3),
      'icon': Icons.workspace_premium,
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress & Penilaian',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Lacak perkembangan belajarmu',
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
                    Tab(text: 'Progress'),
                    Tab(text: 'Nilai'),
                    Tab(text: 'Pencapaian'),
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
                          value: _selectedPeriod,
                          decoration: const InputDecoration(
                            labelText: 'Periode',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                            DropdownMenuItem(value: '2024', child: Text('2024')),
                            DropdownMenuItem(value: '2023', child: Text('2023')),
                          ],
                          onChanged: (value) => setState(() => _selectedPeriod = value!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Content Tabs
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
                        _buildProgressTab(),
                        _buildGradesTab(),
                        _buildAchievementsTab(),
                      ],
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

  Widget _buildProgressTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        final course = _courses[index];
        return _buildProgressCard(course);
      },
    );
  }

  Widget _buildGradesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _grades.length,
      itemBuilder: (context, index) {
        final grade = _grades[index];
        return _buildGradeCard(grade);
      },
    );
  }

  Widget _buildAchievementsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final achievement = _achievements[index];
        return _buildAchievementCard(achievement);
      },
    );
  }

  Widget _buildProgressCard(Map<String, dynamic> course) {
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
                        course['color'],
                        course['color'].withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    course['icon'],
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${course['completedHours']}/${course['totalHours']} jam • Aktivitas terakhir: ${_formatDate(course['lastActivity'])}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(course['progress'] * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: course['color'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: course['progress'],
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(course['color']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeCard(Map<String, dynamic> grade) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    grade['color'],
                    grade['color'].withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  grade['grade'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grade['subject'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${grade['credits']} SKS',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            _buildGradeIndicator(int.parse(grade['grade'])),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    achievement['color'],
                    achievement['color'].withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                achievement['icon'],
                color: Colors.white,
                size: 25,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Diselesaikan: ${achievement['date']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  achievement['score'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const Text(
                  'Skor',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeIndicator(int grade) {
    Color color;
    String status;
    
    if (grade >= 85) {
      color = const Color(0xFF4CAF50);
      status = 'A';
    } else if (grade >= 75) {
      color = const Color(0xFF8BC34A);
      status = 'B';
    } else if (grade >= 65) {
      color = const Color(0xFFFF9800);
      status = 'C';
    } else {
      color = const Color(0xFFFF5722);
      status = 'D';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == 1) {
      return 'Kemarin';
    } else if (difference > 0 && difference < 7) {
      return '$difference hari lalu';
    } else {
      return '${(difference / 7).floor()} minggu lalu';
    }
  }
}