import 'package:flutter/material.dart';
import 'forum/discussion_thread_screen.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  String _selectedCategory = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _discussions = [
    {
      'title': 'Diskusi: Algoritma Sorting yang Efisien',
      'author': 'Ahmad Surya',
      'category': 'Algoritma',
      'replies': 5,
      'views': 45,
      'lastReply': '2024-11-26',
      'isPinned': true,
      'color': const Color(0xFF6C63FF),
      'icon': Icons.sort,
      'preview': 'Bagaimana cara mengimplementasikan algoritma sorting yang efisien untuk dataset besar?',
    },
    {
      'title': 'Pertanyaan: Database Normalization',
      'author': 'Siti Nurhaliza',
      'category': 'Basis Data',
      'replies': 3,
      'views': 28,
      'lastReply': '2024-11-25',
      'isPinned': false,
      'color': const Color(0xFF4CAF50),
      'icon': Icons.storage,
      'preview': 'Masih bingung dengan konsep 3NF dalam normalisasi database. Ada yang bisa menjelaskan?',
    },
    {
      'title': 'Share: Tutorial Flutter Build',
      'author': 'Budi Santoso',
      'category': 'Mobile Development',
      'replies': 12,
      'views': 89,
      'lastReply': '2024-11-26',
      'isPinned': false,
      'color': const Color(0xFF2196F3),
      'icon': Icons.phone_android,
      'preview': 'Saya ingin berbagi tutorial lengkap cara build aplikasi Flutter untuk production.',
    },
    {
      'title': 'Diskusi: Best Practices Web Security',
      'author': 'Maya Putri',
      'category': 'Web Development',
      'replies': 7,
      'views': 56,
      'lastReply': '2024-11-24',
      'isPinned': false,
      'color': const Color(0xFFFF9800),
      'icon': Icons.security,
      'preview': 'Apa saja best practices untuk web security yang harus diterapkan?',
    },
    {
      'title': 'Help: Machine Learning Algorithm',
      'author': 'Rizki Pratama',
      'category': 'AI/ML',
      'replies': 8,
      'views': 34,
      'lastReply': '2024-11-23',
      'isPinned': false,
      'color': const Color(0xFFFF5722),
      'icon': Icons.psychology,
      'preview': 'Bingung pilih algorithm ML yang tepat untuk classification problem.',
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
              Color(0xFF9C27B0),
              Color(0xFFE91E63),
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
                      'Forum Diskusi',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Berdiskusi dan berbagi pengetahuan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Search and Filter Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
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
                          hintText: 'Cari diskusi...',
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
                    const SizedBox(height: 16),
                    // Category Filter
                    Container(
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
                        dropdownColor: const Color(0xFF9C27B0),
                        style: const TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.white,
                        items: const [
                          DropdownMenuItem(value: 'Semua', child: Text('Semua', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'Algoritma', child: Text('Algoritma', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'Basis Data', child: Text('Basis Data', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'Web Development', child: Text('Web Dev', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'Mobile Development', child: Text('Mobile Dev', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'AI/ML', child: Text('AI/ML', style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (value) => setState(() => _selectedCategory = value!),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Discussion List
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
                      itemCount: _filteredDiscussions.length,
                      itemBuilder: (context, index) {
                        final discussion = _filteredDiscussions[index];
                        return _buildDiscussionCard(discussion, context);
                      },
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
          _showNewDiscussionDialog();
        },
        backgroundColor: const Color(0xFF9C27B0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredDiscussions {
    return _discussions.where((discussion) {
      final categoryMatch = _selectedCategory == 'Semua' || discussion['category'] == _selectedCategory;
      final searchMatch = _searchController.text.isEmpty || 
          discussion['title'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          discussion['preview'].toLowerCase().contains(_searchController.text.toLowerCase());
      return categoryMatch && searchMatch;
    }).toList();
  }

  Widget _buildDiscussionCard(Map<String, dynamic> discussion, BuildContext context) {
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
          color: discussion['isPinned'] 
              ? Colors.amber.withOpacity(0.3)
              : discussion['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DiscussionThreadScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Discussion Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          discussion['color'],
                          discussion['color'].withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      discussion['icon'],
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Discussion Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                discussion['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (discussion['isPinned'])
                              const Icon(Icons.push_pin, color: Colors.amber, size: 16),
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
                              discussion['author'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: discussion['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                discussion['category'],
                                style: TextStyle(
                                  color: discussion['color'],
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
              const SizedBox(height: 12),
              // Preview Text
              Text(
                discussion['preview'],
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Stats Row
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${discussion['replies']} balasan',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.visibility,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${discussion['views']} views',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatLastReply(discussion['lastReply']),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatLastReply(String dateString) {
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

  void _showNewDiscussionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Diskusi Baru'),
          content: const TextField(
            decoration: InputDecoration(
              hintText: 'Tulis judul diskusi...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Diskusi baru berhasil dibuat!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Buat'),
            ),
          ],
        );
      },
    );
  }
}