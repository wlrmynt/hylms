import 'package:flutter/material.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _certificates = [
    {
      'title': 'Sertifikat Pemrograman Dasar',
      'course': 'Pemrograman Dasar',
      'completionDate': '2023-11-10',
      'score': '85/100',
      'instructor': 'Dr. Ahmad Surya',
      'credentialId': 'HYLMS-2023-PD-001',
      'color': const Color(0xFFFFC107),
      'icon': Icons.card_giftcard,
    },
    {
      'title': 'Sertifikat Web Development',
      'course': 'Web Development',
      'completionDate': '2023-12-15',
      'score': '92/100',
      'instructor': 'Prof. Siti Nurhaliza',
      'credentialId': 'HYLMS-2023-WD-001',
      'color': const Color(0xFF2196F3),
      'icon': Icons.web,
    },
    {
      'title': 'Sertifikat Database Management',
      'course': 'Database Management',
      'completionDate': '2023-10-20',
      'score': '88/100',
      'instructor': 'Dr. Budi Santoso',
      'credentialId': 'HYLMS-2023-DM-001',
      'color': const Color(0xFF4CAF50),
      'icon': Icons.storage,
    },
  ];

  final List<Map<String, dynamic>> _badges = [
    {
      'title': 'Pemula',
      'description': 'Menyelesaikan kursus pertama',
      'color': const Color(0xFF4CAF50),
      'icon': Icons.star,
      'earned': true,
      'dateEarned': '2023-10-15',
    },
    {
      'title': 'Pembelajaran Konsisten',
      'description': 'Belajar 7 hari berturut-turut',
      'color': const Color(0xFF2196F3),
      'icon': Icons.trending_up,
      'earned': true,
      'dateEarned': '2023-11-01',
    },
    {
      'title': 'Lanjutan',
      'description': 'Menyelesaikan 5 kursus',
      'color': const Color(0xFFFF9800),
      'icon': Icons.star_border,
      'earned': true,
      'dateEarned': '2023-11-20',
    },
    {
      'title': 'Expert',
      'description': 'Nilai rata-rata di atas 90',
      'color': const Color(0xFFFF5722),
      'icon': Icons.grade,
      'earned': false,
      'dateEarned': null,
    },
    {
      'title': 'Forum Contributor',
      'description': 'Memberikan 10 jawaban di forum',
      'color': const Color(0xFF9C27B0),
      'icon': Icons.forum,
      'earned': true,
      'dateEarned': '2023-11-10',
    },
    {
      'title': 'Task Master',
      'description': 'Mengumpulkan semua tugas tepat waktu',
      'color': const Color(0xFF607D8B),
      'icon': Icons.assignment_turned_in,
      'earned': false,
      'dateEarned': null,
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
              Color(0xFFFFC107),
              Color(0xFFFF9800),
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
                      'Sertifikat & Pencapaian',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Rayakan pencapaian belajarmu',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

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
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Cari sertifikat...',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Certificate and Badge Tabs
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TabBar(
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.transparent,
                            tabs: [
                              Tab(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFC107),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('Sertifikat'),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('Lencana'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildCertificatesTab(),
                              _buildBadgesTab(),
                            ],
                          ),
                        ),
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

  Widget _buildCertificatesTab() {
    final searchQuery = _searchController.text.toLowerCase();
    final filteredCertificates = _certificates.where((certificate) {
      if (searchQuery.isEmpty) return true;
      return certificate['title'].toString().toLowerCase().contains(searchQuery) ||
             certificate['course'].toString().toLowerCase().contains(searchQuery) ||
             certificate['instructor'].toString().toLowerCase().contains(searchQuery);
    }).toList();

    if (filteredCertificates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada sertifikat yang ditemukan',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredCertificates.length,
      itemBuilder: (context, index) {
        final certificate = filteredCertificates[index];
        return _buildCertificateCard(certificate);
      },
    );
  }

  Widget _buildBadgesTab() {
    final searchQuery = _searchController.text.toLowerCase();
    final filteredBadges = _badges.where((badge) {
      if (searchQuery.isEmpty) return true;
      return badge['title'].toString().toLowerCase().contains(searchQuery) ||
             badge['description'].toString().toLowerCase().contains(searchQuery);
    }).toList();

    if (filteredBadges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada lencana yang ditemukan',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredBadges.length,
      itemBuilder: (context, index) {
        final badge = filteredBadges[index];
        return _buildBadgeCard(badge);
      },
    );
  }

  Widget _buildCertificateCard(Map<String, dynamic> certificate) {
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
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        certificate['color'],
                        certificate['color'].withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    certificate['icon'],
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certificate['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        certificate['course'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Skor: ${certificate['score']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatDate(certificate['completionDate']),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Instruktur: ${certificate['instructor']}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${certificate['credentialId']}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _downloadCertificate(certificate);
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: certificate['color'],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _shareCertificate(certificate);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Bagikan'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: certificate['color'],
                      side: BorderSide(color: certificate['color']),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> badge) {
    final bool isEarned = badge['earned'];

    return Container(
      decoration: BoxDecoration(
        color: isEarned ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isEarned ? badge['color'].withOpacity(0.3) : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: isEarned
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          badge['color'],
                          badge['color'].withOpacity(0.7),
                        ],
                      )
                    : null,
                color: isEarned ? null : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                badge['icon'],
                color: isEarned ? Colors.white : Colors.grey[600],
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              badge['title'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isEarned ? Colors.black : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              badge['description'],
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (isEarned && badge['dateEarned'] != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badge['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _formatDate(badge['dateEarned']),
                  style: TextStyle(
                    fontSize: 9,
                    color: badge['color'],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (!isEarned)
              Text(
                'Belum tercapai',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey[500],
                ),
              ),
          ],
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
    } else if (difference > 0 && difference < 30) {
      return '$difference hari lalu';
    } else {
      final months = (difference / 30).floor();
      return '$months bulan lalu';
    }
  }

  void _downloadCertificate(Map<String, dynamic> certificate) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mengunduh ${certificate['title']}...')),
    );
  }

  void _shareCertificate(Map<String, dynamic> certificate) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Membagi ${certificate['title']}...')),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}