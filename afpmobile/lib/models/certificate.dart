import 'package:flutter/material.dart';

class Certificate {
  final String title;
  final String instructor;
  final String certificateNumber;
  final String grade;
  final String status;
  final String? description;
  final DateTime? dateIssued;
  final DateTime? expiryDate;

  Certificate({
    required this.title,
    required this.instructor,
    required this.certificateNumber,
    required this.grade,
    required this.status,
    this.description,
    this.dateIssued,
    this.expiryDate,
  });
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
        return Colors.grey;
      case CertificateStatus.approved:
        return Colors.green;
      case CertificateStatus.rejected:
        return Colors.red;
    }
  }
}
