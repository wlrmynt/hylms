import 'package:cloud_firestore/cloud_firestore.dart';

class Certificate {
  final String id;
  final String userId;
  final String courseId;
  final String courseTitle;
  final String userName;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String certificateNumber;
  final String instructorName;
  final String instructorSignature;
  final double finalScore;
  final int totalHours;
  final CertificateStatus status;
  final String? certificateUrl; // URL to generated certificate image/PDF
  final String verificationCode; // For certificate verification
  final DateTime createdAt;
  final Map<String, dynamic> metadata; // Additional certificate data
  
  Certificate({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseTitle,
    required this.userName,
    required this.issueDate,
    this.expiryDate,
    required this.certificateNumber,
    required this.instructorName,
    required this.instructorSignature,
    required this.finalScore,
    required this.totalHours,
    required this.status,
    this.certificateUrl,
    required this.verificationCode,
    required this.createdAt,
    required this.metadata,
  });
  
  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      courseId: json['courseId'] ?? '',
      courseTitle: json['courseTitle'] ?? '',
      userName: json['userName'] ?? '',
      issueDate: (json['issueDate'] as Timestamp).toDate(),
      expiryDate: json['expiryDate'] != null 
          ? (json['expiryDate'] as Timestamp).toDate()
          : null,
      certificateNumber: json['certificateNumber'] ?? '',
      instructorName: json['instructorName'] ?? '',
      instructorSignature: json['instructorSignature'] ?? '',
      finalScore: (json['finalScore'] ?? 0.0).toDouble(),
      totalHours: json['totalHours'] ?? 0,
      status: CertificateStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => CertificateStatus.active,
      ),
      certificateUrl: json['certificateUrl'],
      verificationCode: json['verificationCode'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'userName': userName,
      'issueDate': Timestamp.fromDate(issueDate),
      'expiryDate': expiryDate != null 
          ? Timestamp.fromDate(expiryDate!)
          : null,
      'certificateNumber': certificateNumber,
      'instructorName': instructorName,
      'instructorSignature': instructorSignature,
      'finalScore': finalScore,
      'totalHours': totalHours,
      'status': status.toString().split('.').last,
      'certificateUrl': certificateUrl,
      'verificationCode': verificationCode,
      'createdAt': Timestamp.fromDate(createdAt),
      'metadata': metadata,
    };
  }
  
  // Generate certificate verification URL
  String getVerificationUrl() {
    return 'https://your-domain.com/verify/$verificationCode';
  }
  
  // Check if certificate is still valid
  bool get isValid {
    if (status != CertificateStatus.active) return false;
    if (expiryDate != null && DateTime.now().isAfter(expiryDate!)) return false;
    return true;
  }
}

enum CertificateStatus {
  active,
  expired,
  revoked,
  suspended,
}

class CertificateTemplate {
  final String id;
  final String name;
  final String description;
  final String templateUrl; // URL to certificate template
  final Map<String, dynamic> layoutConfig; // Template configuration
  final bool isActive;
  final String organizationName;
  final String organizationLogo;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  CertificateTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.templateUrl,
    required this.layoutConfig,
    required this.isActive,
    required this.organizationName,
    required this.organizationLogo,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory CertificateTemplate.fromJson(Map<String, dynamic> json) {
    return CertificateTemplate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      templateUrl: json['templateUrl'] ?? '',
      layoutConfig: Map<String, dynamic>.from(json['layoutConfig'] ?? {}),
      isActive: json['isActive'] ?? false,
      organizationName: json['organizationName'] ?? '',
      organizationLogo: json['organizationLogo'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'templateUrl': templateUrl,
      'layoutConfig': layoutConfig,
      'isActive': isActive,
      'organizationName': organizationName,
      'organizationLogo': organizationLogo,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}