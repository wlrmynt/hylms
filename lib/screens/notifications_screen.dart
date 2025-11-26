import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'Semua';
  bool _showUnreadOnly = false;

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Kelas Baru',
      'message': 'Anda telah bergabung ke kelas Pemrograman Web',
      'time': '2024-11-26T10:30:00Z',
      'type': 'class',
      'isRead': false,
      'color': const Color(0xFF2196F3),
      'icon': Icons.class_,
    },
    {
      'title': 'Tugas Baru',
      'message': 'Deadline tugas Algoritma: 15 November 2024',
      'time': '2024-11-25T14:20:00Z',
      'type': 'assignment',
      'isRead': false,
      'color': const Color(0xFFFF9800),
      'icon': Icons.assignment,
    },
    {
      'title': 'Balasan Forum',
      'message': 'Ahmad membalas diskusi Anda: "Algoritma Sorting yang Efisien"',
      'time': '2024-11-26T08:15:00Z',
      'type': 'forum',
      'isRead': true,
      'color': const Color(0xFF4CAF50),
      'icon': Icons.forum,
    },
    {
      'title': 'Pengumuman Penting',
      'message': 'Ujian tengah semester akan dilaksanakan minggu depan',
      'time': '2024-11-20T09:00:00Z',
      'type': 'announcement',
      'isRead': true,
      'color': const Color(0xFFFF5722),
      'icon': Icons.announcement,
    },
    {
      'title': 'Nilai Released',
      'message': 'Nilai kuis Pemrograman Web sudah tersedia',
      'time': '2024-11-24T16:45:00Z',
      'type': 'grade',
      'isRead': false,
      'color': const Color(0xFF9C27B0),
      'icon': Icons.grade,
    },
    {
      'title': 'Sertifikat Siap',
      'message': 'Sertifikat kursus "Pemrograman Dasar" sudah dapat diunduh',
      'time': '2024-11-23T11:30:00Z',
      'type': 'certificate',
      'isRead': true,
      'color': const Color(0xFFFFC107),
      'icon': Icons.card_giftcard,
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
              Color(0xFF00BCD4),
              Color(0xFF009688),
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
                              'Notifikasi',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tetap update dengan informasi terbaru',
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
                            icon: const Icon(Icons.mark_email_read, color: Colors.white),
                            onPressed: _markAllAsRead,
                          ),
                        ),
                      ],
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
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedFilter,
                          decoration: const InputDecoration(
                            labelText: 'Filter',
                            labelStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          ),
                          dropdownColor: const Color(0xFF00BCD4),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white,
                          items: const [
                            DropdownMenuItem(value: 'Semua', child: Text('Semua', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'class', child: Text('Kelas', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'assignment', child: Text('Tugas', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'forum', child: Text('Forum', style: TextStyle(color: Colors.white))),
                            DropdownMenuItem(value: 'announcement', child: Text('Pengumuman', style: TextStyle(color: Colors.white))),
                          ],
                          onChanged: (value) => setState(() => _selectedFilter = value!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: Icon(
                          _showUnreadOnly ? Icons.filter_alt : Icons.filter_alt_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _showUnreadOnly = !_showUnreadOnly;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Unread Count Badge
              if (_unreadCount > 0)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        '$_unreadCount notifikasi belum dibaca',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              // Notification List
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
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return _buildNotificationCard(notification, context);
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

  List<Map<String, dynamic>> get _filteredNotifications {
    return _notifications.where((notification) {
      final filterMatch = _selectedFilter == 'Semua' || notification['type'] == _selectedFilter;
      final unreadMatch = !_showUnreadOnly || !notification['isRead'];
      return filterMatch && unreadMatch;
    }).toList();
  }

  int get _unreadCount => _notifications.where((n) => !n['isRead']).length;

  Widget _buildNotificationCard(Map<String, dynamic> notification, BuildContext context) {
    final bool isUnread = !notification['isRead'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFF3F4F6) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnread ? const Color(0xFF00BCD4).withOpacity(0.3) : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _markAsRead(notification),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Notification Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      notification['color'],
                      notification['color'].withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  notification['icon'],
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00BCD4),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(notification['time']),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              // Action Button
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onPressed: () => _showNotificationMenu(notification),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String timeString) {
    final time = DateTime.parse(timeString);
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${(difference.inDays / 7).floor()} minggu lalu';
    }
  }

  void _markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['isRead'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua notifikasi telah dibaca')),
    );
  }

  void _showNotificationMenu(Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  notification['isRead'] ? Icons.mark_email_unread : Icons.mark_email_read,
                  color: const Color(0xFF00BCD4),
                ),
                title: Text(notification['isRead'] ? 'Tandai Belum Dibaca' : 'Tandai Dibaca'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    notification['isRead'] = !notification['isRead'];
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Hapus Notifikasi'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _notifications.remove(notification);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}