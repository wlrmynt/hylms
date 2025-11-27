import 'package:cloud_firestore/cloud_firestore.dart';

class StructuredClass {
  final String id;
  final String title;
  final String description;
  final String instructorId;
  final String instructorName;
  final String courseId;
  final String courseTitle;
  final ClassStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int maxStudents;
  final int currentEnrollment;
  final List<String> enrolledStudents;
  final List<String> classSchedule; // Schedule times
  final List<String> classMaterials;
  final String classroom; // Physical or virtual classroom
  final ClassType type;
  final int credits;
  final double price;
  final String? syllabusUrl;
  final String? coverImageUrl;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  StructuredClass({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorId,
    required this.instructorName,
    required this.courseId,
    required this.courseTitle,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.maxStudents,
    required this.currentEnrollment,
    required this.enrolledStudents,
    required this.classSchedule,
    required this.classMaterials,
    required this.classroom,
    required this.type,
    required this.credits,
    required this.price,
    this.syllabusUrl,
    this.coverImageUrl,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory StructuredClass.fromJson(Map<String, dynamic> json) {
    return StructuredClass(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructorId: json['instructorId'] ?? '',
      instructorName: json['instructorName'] ?? '',
      courseId: json['courseId'] ?? '',
      courseTitle: json['courseTitle'] ?? '',
      status: ClassStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ClassStatus.draft,
      ),
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      maxStudents: json['maxStudents'] ?? 30,
      currentEnrollment: json['currentEnrollment'] ?? 0,
      enrolledStudents: List<String>.from(json['enrolledStudents'] ?? []),
      classSchedule: List<String>.from(json['classSchedule'] ?? []),
      classMaterials: List<String>.from(json['classMaterials'] ?? []),
      classroom: json['classroom'] ?? '',
      type: ClassType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ClassType.regular,
      ),
      credits: json['credits'] ?? 3,
      price: (json['price'] ?? 0.0).toDouble(),
      syllabusUrl: json['syllabusUrl'],
      coverImageUrl: json['coverImageUrl'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'status': status.toString().split('.').last,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'maxStudents': maxStudents,
      'currentEnrollment': currentEnrollment,
      'enrolledStudents': enrolledStudents,
      'classSchedule': classSchedule,
      'classMaterials': classMaterials,
      'classroom': classroom,
      'type': type.toString().split('.').last,
      'credits': credits,
      'price': price,
      'syllabusUrl': syllabusUrl,
      'coverImageUrl': coverImageUrl,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
  
  // Check if class is currently accepting enrollments
  bool get isEnrollmentOpen {
    return status == ClassStatus.enrollmentOpen && 
           DateTime.now().isBefore(startDate) &&
           currentEnrollment < maxStudents;
  }
  
  // Check if class is currently active
  bool get isActive {
    return status == ClassStatus.active && 
           DateTime.now().isAfter(startDate) &&
           DateTime.now().isBefore(endDate);
  }
  
  // Get enrollment availability
  int get availableSpots => maxStudents - currentEnrollment;
}

enum ClassStatus {
  draft,
  enrollmentOpen,
  active,
  completed,
  cancelled,
  archived,
}

enum ClassType {
  regular,
  intensive,
  online,
  hybrid,
  workshop,
  seminar,
}

class ClassEnrollment {
  final String id;
  final String classId;
  final String studentId;
  final String studentName;
  final EnrollmentStatus status;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final double finalGrade;
  final bool certificateIssued;
  final Map<String, dynamic> attendance;
  final List<String> completedAssignments;
  final Map<String, dynamic> metadata;
  
  ClassEnrollment({
    required this.id,
    required this.classId,
    required this.studentId,
    required this.studentName,
    required this.status,
    required this.enrolledAt,
    this.completedAt,
    required this.finalGrade,
    required this.certificateIssued,
    required this.attendance,
    required this.completedAssignments,
    required this.metadata,
  });
  
  factory ClassEnrollment.fromJson(Map<String, dynamic> json) {
    return ClassEnrollment(
      id: json['id'] ?? '',
      classId: json['classId'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      status: EnrollmentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => EnrollmentStatus.enrolled,
      ),
      enrolledAt: (json['enrolledAt'] as Timestamp).toDate(),
      completedAt: json['completedAt'] != null 
          ? (json['completedAt'] as Timestamp).toDate()
          : null,
      finalGrade: (json['finalGrade'] ?? 0.0).toDouble(),
      certificateIssued: json['certificateIssued'] ?? false,
      attendance: Map<String, dynamic>.from(json['attendance'] ?? {}),
      completedAssignments: List<String>.from(json['completedAssignments'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classId': classId,
      'studentId': studentId,
      'studentName': studentName,
      'status': status.toString().split('.').last,
      'enrolledAt': Timestamp.fromDate(enrolledAt),
      'completedAt': completedAt != null 
          ? Timestamp.fromDate(completedAt!)
          : null,
      'finalGrade': finalGrade,
      'certificateIssued': certificateIssued,
      'attendance': attendance,
      'completedAssignments': completedAssignments,
      'metadata': metadata,
    };
  }
}

enum EnrollmentStatus {
  enrolled,
  dropped,
  completed,
  withdrew,
  failed,
}

class ClassSession {
  final String id;
  final String classId;
  final String title;
  final String description;
  final DateTime scheduledTime;
  final int duration; // in minutes
  final String location;
  final SessionType type;
  final List<String> materials;
  final String? recordingUrl;
  final String? presentationUrl;
  final int attendanceCount;
  final Map<String, bool> studentAttendance;
  final String instructorNotes;
  final DateTime createdAt;
  
  ClassSession({
    required this.id,
    required this.classId,
    required this.title,
    required this.description,
    required this.scheduledTime,
    required this.duration,
    required this.location,
    required this.type,
    required this.materials,
    this.recordingUrl,
    this.presentationUrl,
    required this.attendanceCount,
    required this.studentAttendance,
    required this.instructorNotes,
    required this.createdAt,
  });
  
  factory ClassSession.fromJson(Map<String, dynamic> json) {
    return ClassSession(
      id: json['id'] ?? '',
      classId: json['classId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      scheduledTime: (json['scheduledTime'] as Timestamp).toDate(),
      duration: json['duration'] ?? 60,
      location: json['location'] ?? '',
      type: SessionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => SessionType.lecture,
      ),
      materials: List<String>.from(json['materials'] ?? []),
      recordingUrl: json['recordingUrl'],
      presentationUrl: json['presentationUrl'],
      attendanceCount: json['attendanceCount'] ?? 0,
      studentAttendance: Map<String, bool>.from(json['studentAttendance'] ?? {}),
      instructorNotes: json['instructorNotes'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classId': classId,
      'title': title,
      'description': description,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'duration': duration,
      'location': location,
      'type': type.toString().split('.').last,
      'materials': materials,
      'recordingUrl': recordingUrl,
      'presentationUrl': presentationUrl,
      'attendanceCount': attendanceCount,
      'studentAttendance': studentAttendance,
      'instructorNotes': instructorNotes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

enum SessionType {
  lecture,
  lab,
  discussion,
  exam,
  presentation,
  workshop,
}