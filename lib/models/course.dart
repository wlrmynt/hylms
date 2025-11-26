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
  });
  
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
      createdAt: DateTime.now(),
    );
  }
  
  static int _parseDuration(String duration) {
    // Extract number from strings like "10 jam", "15 jam", etc.
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(duration);
    return match != null ? int.parse(match.group(1)!) : 10;
  }
}