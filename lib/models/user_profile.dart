import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String role; // Mahasiswa, Dosen
  final String skillLevel; // Beginner, Intermediate, Advanced
  final List<String> interests;
  final String preferredLearningStyle; // Visual, Hands-on, Theoretical
  final int availableHoursPerWeek;
  final DateTime createdAt;
  final DateTime lastActive;
  DateTime updatedAt;
  
  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.skillLevel,
    required this.interests,
    required this.preferredLearningStyle,
    required this.availableHoursPerWeek,
    required this.createdAt,
    required this.lastActive,
  }) : updatedAt = DateTime.now();
  
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'Mahasiswa',
      skillLevel: json['skillLevel'] ?? 'Beginner',
      interests: List<String>.from(json['interests'] ?? []),
      preferredLearningStyle: json['preferredLearningStyle'] ?? 'Hands-on',
      availableHoursPerWeek: json['availableHoursPerWeek'] ?? 10,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastActive: (json['lastActive'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'skillLevel': skillLevel,
      'interests': interests,
      'preferredLearningStyle': preferredLearningStyle,
      'availableHoursPerWeek': availableHoursPerWeek,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
  
  factory UserProfile.mock() {
    return UserProfile(
      id: '1',
      email: 'john@example.com',
      name: 'John Doe',
      role: 'Mahasiswa',
      skillLevel: 'Intermediate',
      interests: ['Pemrograman', 'AI', 'Web Development'],
      preferredLearningStyle: 'Hands-on',
      availableHoursPerWeek: 10,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastActive: DateTime.now(),
    );
  }
}