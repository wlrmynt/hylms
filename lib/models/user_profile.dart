class UserProfile {
  final String id;
  final String name;
  final String skillLevel; // Beginner, Intermediate, Advanced
  final List<String> interests;
  final String preferredLearningStyle; // Visual, Hands-on, Theoretical
  final int availableHoursPerWeek;
  final DateTime createdAt;
  final DateTime lastActive;
  
  UserProfile({
    required this.id,
    required this.name,
    required this.skillLevel,
    required this.interests,
    required this.preferredLearningStyle,
    required this.availableHoursPerWeek,
    required this.createdAt,
    required this.lastActive,
  });
  
  factory UserProfile.mock() {
    return UserProfile(
      id: '1',
      name: 'John Doe',
      skillLevel: 'Intermediate',
      interests: ['Pemrograman', 'AI', 'Web Development'],
      preferredLearningStyle: 'Hands-on',
      availableHoursPerWeek: 10,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastActive: DateTime.now(),
    );
  }
}