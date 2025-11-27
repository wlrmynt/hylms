import 'package:cloud_firestore/cloud_firestore.dart';

enum CourseType {
  selfPaced,
  structured,
  hybrid,
  workshop,
  seminar,
}

class Course {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final int durationHours;
  final int students;
  final double rating;
  final String? imageUrl;
  final DateTime? createdAt;
  
  // AI-specific properties
  double aiScore = 0.0;
  String? aiReason;
  
  // LMS-specific properties
  final String description;
  final String instructorId;
  final String instructorName;
  final List<String> learningObjectives;
  final List<String> prerequisites;
  final List<String> tags;
  final CourseType type;
  final bool isActive;
  final bool hasStructuredClass;
  final String? syllabusUrl;
  final List<String> materials;
  final Map<String, dynamic> metadata;
  final DateTime updatedAt;
  final int version;
  
  Course({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.durationHours,
    required this.students,
    required this.rating,
    this.imageUrl,
    this.createdAt,
    this.description = '',
    this.instructorId = '',
    this.instructorName = '',
    this.learningObjectives = const [],
    this.prerequisites = const [],
    this.tags = const [],
    this.type = CourseType.selfPaced,
    this.isActive = true,
    this.hasStructuredClass = false,
    this.syllabusUrl,
    this.materials = const [],
    this.metadata = const {},
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now(),
       version = 1;
  
  // Create from existing kursus_mandiri_screen.dart data format
  factory Course.fromKursusData(Map<String, dynamic> data, String id) {
    return Course(
      id: id,
      title: data['title'],
      category: data['category'],
      difficulty: data['difficulty'],
      durationHours: _parseDuration(data['duration']),
      students: data['students'],
      rating: data['rating'].toDouble(),
      imageUrl: data['image'],
      description: data['description'] ?? 'Comprehensive course on ${data['title']}',
      instructorName: data['instructor'] ?? 'Course Instructor',
      learningObjectives: data['learningObjectives'] ?? [],
      tags: data['tags'] ?? [data['category'].toString().toLowerCase()],
      type: CourseType.selfPaced,
      materials: data['materials'] ?? [],
    );
  }
  
  static int _parseDuration(String duration) {
    // Extract number from strings like "10 jam", "15 jam", etc.
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(duration);
    return match != null ? int.parse(match.group(1)!) : 10;
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? '',
      durationHours: json['durationHours'] ?? 0,
      students: json['students'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      description: json['description'] ?? '',
      instructorId: json['instructorId'] ?? '',
      instructorName: json['instructorName'] ?? '',
      learningObjectives: List<String>.from(json['learningObjectives'] ?? []),
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      type: CourseType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => CourseType.selfPaced,
      ),
      isActive: json['isActive'] ?? true,
      hasStructuredClass: json['hasStructuredClass'] ?? false,
      syllabusUrl: json['syllabusUrl'],
      materials: List<String>.from(json['materials'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'difficulty': difficulty,
      'durationHours': durationHours,
      'students': students,
      'rating': rating,
      'imageUrl': imageUrl,
      'createdAt': createdAt != null 
          ? Timestamp.fromDate(createdAt!)
          : null,
      'description': description,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'learningObjectives': learningObjectives,
      'prerequisites': prerequisites,
      'tags': tags,
      'type': type.toString().split('.').last,
      'isActive': isActive,
      'hasStructuredClass': hasStructuredClass,
      'syllabusUrl': syllabusUrl,
      'materials': materials,
      'metadata': metadata,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'version': version,
    };
  }
}