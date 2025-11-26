import '../models/course.dart';
import '../models/user_profile.dart';

class AIRecommendationService {
  // Mock AI-powered course recommendations
  // In a real app, this would connect to an AI/ML service
  
  static List<Course> getPersonalizedRecommendations({
    required UserProfile userProfile,
    List<Course>? completedCourses,
    List<Course>? availableCourses,
  }) {
    if (availableCourses == null || availableCourses.isEmpty) {
      return [];
    }
    
    // Simulate AI analysis based on user profile and learning history
    final recommendations = <Course>[];
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    
    // Filter based on user interests and skill level
    for (final course in availableCourses) {
      double score = 0.0;
      
      // Interest matching score (0-40 points)
      if (userProfile.interests.any((interest) => 
          course.title.toLowerCase().contains(interest.toLowerCase()) ||
          course.category.toLowerCase().contains(interest.toLowerCase()))) {
        score += 40.0;
      }
      
      // Skill level matching (0-30 points)
      final skillLevelMatch = _getSkillLevelMatch(userProfile.skillLevel, course.difficulty);
      score += skillLevelMatch * 30.0;
      
      // Learning style preference (0-20 points)
      final learningStyleScore = _getLearningStyleScore(userProfile.preferredLearningStyle, course);
      score += learningStyleScore;
      
      // Time availability consideration (0-10 points)
      final timeScore = _getTimeAvailabilityScore(userProfile.availableHoursPerWeek, course.durationHours);
      score += timeScore;
      
      // Add some randomness for variety (0-5 points)
      score += (random % 6) * 0.8;
      
      // Don't recommend courses already completed
      if (completedCourses?.any((completed) => completed.id == course.id) ?? false) {
        continue;
      }
      
      course.aiScore = score;
      recommendations.add(course);
    }
    
    // Sort by AI score and return top recommendations
    recommendations.sort((a, b) => b.aiScore.compareTo(a.aiScore));
    return recommendations.take(3).toList(); // Return top 3 recommendations
  }
  
  static String getAIRecommendationReason(Course course) {
    final reasons = [
      'Berdasarkan minat Anda di ${course.category}',
      'Sesuai dengan level skill Anda',
      'Cocok dengan gaya belajar Anda',
      'Rekomendasi AI untuk pengembangan skill',
      'Berdasarkan pola belajar Anda',
      'Direkomendasikan oleh sistem AI',
    ];
    
    // Select reason based on course properties
    if (course.difficulty.toLowerCase() == 'beginner') {
      return 'Berdasarkan minat Anda di ${course.category}';
    } else if (course.difficulty.toLowerCase() == 'advanced') {
      return 'Sesuai dengan level skill Anda';
    } else {
      return reasons[course.aiScore.floor() % reasons.length];
    }
  }
  
  static double _getSkillLevelMatch(String userLevel, String courseDifficulty) {
    final skillLevels = ['Beginner', 'Intermediate', 'Advanced'];
    final userIndex = skillLevels.indexOf(userLevel);
    final courseIndex = skillLevels.indexOf(courseDifficulty);
    
    // Perfect match gets highest score
    if (userIndex == courseIndex) return 1.0;
    
    // One level difference gets medium score
    if ((userIndex - courseIndex).abs() == 1) return 0.7;
    
    // Too far apart gets low score
    return 0.3;
  }
  
  static double _getLearningStyleScore(String learningStyle, Course course) {
    // Simplified scoring based on course type and duration
    if (learningStyle.toLowerCase() == 'visual' && course.durationHours <= 15) {
      return 20.0;
    } else if (learningStyle.toLowerCase() == 'hands-on' && course.difficulty.toLowerCase() != 'advanced') {
      return 18.0;
    } else if (learningStyle.toLowerCase() == 'theoretical' && course.category.toLowerCase().contains('programming')) {
      return 15.0;
    }
    return 10.0;
  }
  
  static double _getTimeAvailabilityScore(int availableHours, int courseHours) {
    if (availableHours >= courseHours) return 10.0;
    if (availableHours >= courseHours * 0.7) return 7.0;
    if (availableHours >= courseHours * 0.5) return 5.0;
    return 2.0;
  }
}