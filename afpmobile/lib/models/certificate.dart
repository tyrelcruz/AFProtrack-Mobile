import 'package:flutter/material.dart';

class Certificate {
  final String id;
  final String userId;
  final String? trainingProgramId;
  final String fileName;
  final String cloudinaryId;
  final String cloudinaryUrl;
  final String fileType;
  final int fileSize;
  final String status;
  final String submittedBy;
  final String description;
  final DateTime submittedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? reviewNotes;
  final DateTime? reviewedAt;
  final Reviewer? reviewedBy;
  final String formattedFileSize;

  Certificate({
    required this.id,
    required this.userId,
    this.trainingProgramId,
    required this.fileName,
    required this.cloudinaryId,
    required this.cloudinaryUrl,
    required this.fileType,
    required this.fileSize,
    required this.status,
    required this.submittedBy,
    required this.description,
    required this.submittedAt,
    required this.createdAt,
    required this.updatedAt,
    this.reviewNotes,
    this.reviewedAt,
    this.reviewedBy,
    required this.formattedFileSize,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['userId'] ?? '',
      trainingProgramId: json['trainingProgramId'],
      fileName: json['fileName'] ?? '',
      cloudinaryId: json['cloudinaryId'] ?? '',
      cloudinaryUrl: json['cloudinaryUrl'] ?? '',
      fileType: json['fileType'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      status: json['status'] ?? '',
      submittedBy: json['submittedBy'] ?? '',
      description: json['description'] ?? '',
      submittedAt: DateTime.parse(
        json['submittedAt'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      reviewNotes: json['reviewNotes'],
      reviewedAt:
          json['reviewedAt'] != null
              ? DateTime.parse(json['reviewedAt'])
              : null,
      reviewedBy:
          json['reviewedBy'] != null
              ? Reviewer.fromJson(json['reviewedBy'])
              : null,
      formattedFileSize: json['formattedFileSize'] ?? '',
    );
  }

  // Computed properties for backward compatibility
  String get title => description;
  String get instructor => reviewedBy?.fullName ?? 'N/A';
  String get certificateNumber => id;
  String get grade => status == 'approved' ? 'A+' : 'N/A';
}

class Reviewer {
  final String id;
  final String firstName;
  final String lastName;
  final String serviceId;
  final String fullName;
  final String avatar;

  Reviewer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.serviceId,
    required this.fullName,
    required this.avatar,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'] ?? json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      serviceId: json['serviceId'] ?? '',
      fullName: json['fullName'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}

enum CertificateStatus { pending, approved, rejected }

extension CertificateStatusExtension on CertificateStatus {
  String get displayName {
    switch (this) {
      case CertificateStatus.pending:
        return 'Pending';
      case CertificateStatus.approved:
        return 'Approved';
      case CertificateStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case CertificateStatus.pending:
        return Colors.orange;
      case CertificateStatus.approved:
        return Colors.green;
      case CertificateStatus.rejected:
        return Colors.red;
    }
  }
}
