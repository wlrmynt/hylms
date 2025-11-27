import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/certificate.dart';
import '../models/course.dart';
import '../models/user_profile.dart';
import '../models/user_progress.dart';

class CertificateService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  static CollectionReference get certificatesCollection => 
      _firestore.collection('certificates');
  static CollectionReference get templatesCollection => 
      _firestore.collection('certificate_templates');
  
  // Generate certificate for completed course
  static Future<Certificate?> generateCertificate({
    required String userId,
    required String courseId,
    required Course course,
    required UserProfile userProfile,
    required UserProgress progress,
    String? templateId,
    String? instructorName,
    String? instructorSignature,
  }) async {
    try {
      // Input validation
      if (userId.isEmpty || courseId.isEmpty) {
        throw ArgumentError('User ID and Course ID are required');
      }
      
      if (course.title.isEmpty || userProfile.name.isEmpty) {
        throw ArgumentError('Course title and user name are required');
      }
      
      // Validate eligibility for certificate
      if (!_isEligibleForCertificate(progress, course)) {
        throw StateError('User not eligible for certificate');
      }
      
      // Check if certificate already exists
      Certificate? existingCertificate = await getUserCourseCertificate(userId, courseId);
      if (existingCertificate != null) {
        return existingCertificate;
      }
      
      // Get certificate template
      CertificateTemplate template = await _getActiveTemplate(templateId);
      
      // Generate certificate data
      String certificateNumber = await _generateCertificateNumber();
      String verificationCode = _generateVerificationCode(userId, courseId, certificateNumber);
      
      Certificate certificate = Certificate(
        id: '',
        userId: userId,
        courseId: courseId,
        courseTitle: course.title,
        userName: userProfile.name,
        issueDate: DateTime.now(),
        expiryDate: _calculateExpiryDate(), // 2 years from issue
        certificateNumber: certificateNumber,
        instructorName: instructorName ?? (course.instructorName.isNotEmpty ? course.instructorName : 'Course Instructor'),
        instructorSignature: instructorSignature ?? 'Digital Signature',
        finalScore: progress.averageScore,
        totalHours: course.durationHours,
        status: CertificateStatus.active,
        certificateUrl: null, // Will be generated later
        verificationCode: verificationCode,
        createdAt: DateTime.now(),
        metadata: {
          'completionDate': Timestamp.fromDate(DateTime.now()),
          'totalLessonsCompleted': progress.totalLessonsCompleted,
          'totalAssignmentsCompleted': progress.totalAssignmentsCompleted,
          'timeSpent': progress.timeSpent.totalMinutes,
          'templateUsed': template.id,
          'institutionName': template.organizationName,
        },
      );
      
      DocumentReference doc = await certificatesCollection.add(certificate.toJson());
      String certificateId = doc.id;
      
      // In a real application, you would generate the actual certificate image/PDF here
      // For now, we'll simulate it
      String certificateUrl = await _generateCertificateImage(certificate, template);
      
      await certificatesCollection.doc(certificateId).update({
        'certificateUrl': certificateUrl,
      });
      
      return certificate.copyWith(id: certificateId, certificateUrl: certificateUrl);
    } catch (e) {
      print('Error generating certificate: $e');
      throw Exception('Failed to generate certificate: $e');
    }
  }
  
  // Get user's certificate for a specific course
  static Future<Certificate?> getUserCourseCertificate(String userId, String courseId) async {
    try {
      QuerySnapshot snapshot = await certificatesCollection
          .where('userId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
        data['id'] = snapshot.docs.first.id;
        return Certificate.fromJson(data);
      }
    } catch (e) {
      print('Error getting user course certificate: $e');
    }
    return null;
  }
  
  // Get all certificates for a user
  static Future<List<Certificate>> getUserCertificates(String userId) async {
    try {
      QuerySnapshot snapshot = await certificatesCollection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: CertificateStatus.active.toString().split('.').last)
          .orderBy('issueDate', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Certificate.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting user certificates: $e');
      return [];
    }
  }
  
  // Verify certificate by verification code
  static Future<Certificate?> verifyCertificate(String verificationCode) async {
    try {
      QuerySnapshot snapshot = await certificatesCollection
          .where('verificationCode', isEqualTo: verificationCode)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
        data['id'] = snapshot.docs.first.id;
        Certificate certificate = Certificate.fromJson(data);
        
        // Check if certificate is still valid
        if (certificate.isValid) {
          return certificate;
        }
      }
    } catch (e) {
      print('Error verifying certificate: $e');
    }
    return null;
  }
  
  // Get certificate statistics for an instructor
  static Future<Map<String, dynamic>> getInstructorCertificateStats(String instructorName) async {
    try {
      QuerySnapshot snapshot = await certificatesCollection
          .where('instructorName', isEqualTo: instructorName)
          .orderBy('issueDate', descending: true)
          .get();
      
      List<Certificate> certificates = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Certificate.fromJson(data);
      }).toList();
      
      int totalCertificates = certificates.length;
      int activeCertificates = certificates.where((c) => c.status == CertificateStatus.active).length;
      int expiredCertificates = certificates.where((c) => c.status == CertificateStatus.expired).length;
      int revokedCertificates = certificates.where((c) => c.status == CertificateStatus.revoked).length;
      
      // Group by course
      Map<String, int> certificatesByCourse = {};
      for (Certificate cert in certificates) {
        certificatesByCourse[cert.courseTitle] = 
            (certificatesByCourse[cert.courseTitle] ?? 0) + 1;
      }
      
      // Calculate average scores
      double averageScore = certificates.isNotEmpty 
          ? certificates.map((c) => c.finalScore).reduce((a, b) => a + b) / certificates.length
          : 0.0;
      
      return {
        'totalCertificates': totalCertificates,
        'activeCertificates': activeCertificates,
        'expiredCertificates': expiredCertificates,
        'revokedCertificates': revokedCertificates,
        'averageScore': double.parse(averageScore.toStringAsFixed(2)),
        'certificatesByCourse': certificatesByCourse,
        'certificates': certificates,
      };
    } catch (e) {
      print('Error getting instructor certificate stats: $e');
      return {
        'totalCertificates': 0,
        'activeCertificates': 0,
        'expiredCertificates': 0,
        'revokedCertificates': 0,
        'averageScore': 0.0,
        'certificatesByCourse': {},
        'certificates': [],
      };
    }
  }
  
  // Revoke certificate
  static Future<void> revokeCertificate(String certificateId, String reason) async {
    try {
      await certificatesCollection.doc(certificateId).update({
        'status': CertificateStatus.revoked.toString().split('.').last,
        'metadata.revocationReason': reason,
        'metadata.revokedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error revoking certificate: $e');
      throw Exception('Failed to revoke certificate: $e');
    }
  }
  
  // Create certificate template
  static Future<String> createTemplate(CertificateTemplate template) async {
    try {
      DocumentReference doc = await templatesCollection.add(template.toJson());
      return doc.id;
    } catch (e) {
      print('Error creating certificate template: $e');
      throw Exception('Failed to create certificate template: $e');
    }
  }
  
  // Get active certificate templates
  static Future<List<CertificateTemplate>> getActiveTemplates() async {
    try {
      QuerySnapshot snapshot = await templatesCollection
          .where('isActive', isEqualTo: true)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CertificateTemplate.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting active templates: $e');
      return [];
    }
  }
  
  // Helper methods
  static bool _isEligibleForCertificate(UserProgress progress, Course course) {
    // Check completion percentage
    if (progress.completionPercentage < 100.0) return false;
    
    // Check minimum score requirement (70%)
    if (progress.averageScore < 70.0) return false;
    
    // Check if all required assignments are completed
    if (progress.totalAssignments > 0 && 
        progress.totalAssignmentsCompleted < progress.totalAssignments) {
      return false;
    }
    
    return true;
  }
  
  static Future<String> _generateCertificateNumber() async {
    // Generate unique certificate number
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String random = DateTime.now().microsecond.toString();
    return 'CERT-$timestamp-$random';
  }
  
  static String _generateVerificationCode(String userId, String courseId, String certificateNumber) {
    if (userId.isEmpty || courseId.isEmpty || certificateNumber.isEmpty) {
      throw ArgumentError('All parameters must be non-empty for verification code generation');
    }
    
    String data = '$userId-$courseId-$certificateNumber-${DateTime.now().millisecondsSinceEpoch}';
    // Simple hash function for verification code
    int hash = data.hashCode;
    String code = hash.abs().toRadixString(16).toUpperCase();
    return code.substring(0, 16); // Take first 16 characters
  }
  
  static DateTime _calculateExpiryDate() {
    return DateTime.now().add(const Duration(days: 730)); // 2 years
  }
  
  static Future<CertificateTemplate> _getActiveTemplate(String? templateIdParam) async {
    if (templateIdParam != null) {
      DocumentSnapshot doc = await templatesCollection.doc(templateIdParam).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CertificateTemplate.fromJson(data);
      }
    }
    
    // Get first active template or create default
    List<CertificateTemplate> templates = await getActiveTemplates();
    if (templates.isNotEmpty) {
      return templates.first;
    }
    
    // Create and return a default template
    CertificateTemplate defaultTemplate = CertificateTemplate(
      id: '',
      name: 'Default Certificate',
      description: 'Standard course completion certificate',
      templateUrl: 'https://via.placeholder.com/800x600/4CAF50/FFFFFF?text=Certificate',
      layoutConfig: {
        'width': 800,
        'height': 600,
        'fontFamily': 'Arial',
        'backgroundColor': '#FFFFFF',
        'textColor': '#000000',
      },
      isActive: true,
      organizationName: 'HYLMS Learning Platform',
      organizationLogo: 'https://via.placeholder.com/200x100/4CAF50/FFFFFF?text=HYLMS',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    String newTemplateId = await createTemplate(defaultTemplate);
    return CertificateTemplate(
      id: newTemplateId,
      name: defaultTemplate.name,
      description: defaultTemplate.description,
      templateUrl: defaultTemplate.templateUrl,
      layoutConfig: defaultTemplate.layoutConfig,
      isActive: defaultTemplate.isActive,
      organizationName: defaultTemplate.organizationName,
      organizationLogo: defaultTemplate.organizationLogo,
      createdAt: defaultTemplate.createdAt,
      updatedAt: defaultTemplate.updatedAt,
    );
  }
  
  static Future<String> _generateCertificateImage(Certificate certificate, CertificateTemplate template) async {
    // In a real application, this would generate an actual certificate image/PDF
    // using libraries like pdf, image, or canvas
    // For now, we'll return a placeholder URL
    
    return 'https://via.placeholder.com/800x600/4CAF50/FFFFFF?text=${Uri.encodeComponent(certificate.certificateNumber)}';
  }
  
  // Clean up expired certificates
  static Future<void> cleanupExpiredCertificates() async {
    try {
      // Use server timestamp for more accurate expiry checking
      QuerySnapshot activeSnapshots = await certificatesCollection
          .where('status', isEqualTo: CertificateStatus.active.toString().split('.').last)
          .where('expiryDate', isLessThan: Timestamp.now())
          .get();
      
      List<DocumentSnapshot> expiredCertificates = activeSnapshots.docs;
      
      // Update status to expired in batch for better performance
      WriteBatch batch = _firestore.batch();
      
      for (DocumentSnapshot doc in expiredCertificates) {
        DocumentReference docRef = certificatesCollection.doc(doc.id);
        batch.update(docRef, {
          'status': CertificateStatus.expired.toString().split('.').last,
          'metadata.expiredAt': Timestamp.fromDate(DateTime.now()),
        });
      }
      
      // Commit the batch update
      if (expiredCertificates.isNotEmpty) {
        await batch.commit();
      }
      
      print('Cleaned up ${expiredCertificates.length} expired certificates');
    } catch (e) {
      print('Error cleaning up expired certificates: $e');
    }
  }
}

// Extension to add copyWith method to Certificate
extension CertificateCopy on Certificate {
  Certificate copyWith({
    String? id,
    String? userId,
    String? courseId,
    String? courseTitle,
    String? userName,
    DateTime? issueDate,
    DateTime? expiryDate,
    String? certificateNumber,
    String? instructorName,
    String? instructorSignature,
    double? finalScore,
    int? totalHours,
    CertificateStatus? status,
    String? certificateUrl,
    String? verificationCode,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return Certificate(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      userName: userName ?? this.userName,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      instructorName: instructorName ?? this.instructorName,
      instructorSignature: instructorSignature ?? this.instructorSignature,
      finalScore: finalScore ?? this.finalScore,
      totalHours: totalHours ?? this.totalHours,
      status: status ?? this.status,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      verificationCode: verificationCode ?? this.verificationCode,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}