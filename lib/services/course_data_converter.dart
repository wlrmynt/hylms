import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseDataConverter {
  // Convert existing kursus_mandiri data to Course model format
  static List<Course> convertExistingCourseData() {
    // This data comes from kursus_mandiri_screen.dart
    final existingData = [
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

    return existingData.asMap().entries.map((entry) {
      return Course.fromKursusData(entry.value, 'course_${entry.key}');
    }).toList();
  }
}