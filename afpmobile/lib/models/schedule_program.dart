import 'package:flutter/material.dart';

class ScheduleProgram {
  final String id;
  final String programName;
  final String startDate;
  final String endDate;
  final String enrollmentStartDate;
  final String enrollmentEndDate;
  final String startTime;
  final String endTime;
  final String instructor;
  final String venue;
  final int maxParticipants;
  final String additionalDetails;
  final String batch;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int duration;
  final int currentEnrollment;
  final int availableSlots;
  final bool isFull;
  final int enrollmentPercentage;
  final String calculatedStatus;
  final List<SessionMetadata> sessionMetadata;
  final EnrollmentDetails enrollmentDetails;

  const ScheduleProgram({
    required this.id,
    required this.programName,
    required this.startDate,
    required this.endDate,
    required this.enrollmentStartDate,
    required this.enrollmentEndDate,
    required this.startTime,
    required this.endTime,
    required this.instructor,
    required this.venue,
    required this.maxParticipants,
    required this.additionalDetails,
    required this.batch,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.duration,
    required this.currentEnrollment,
    required this.availableSlots,
    required this.isFull,
    required this.enrollmentPercentage,
    required this.calculatedStatus,
    required this.sessionMetadata,
    required this.enrollmentDetails,
  });

  // Format date range for display
  String get dateTimeRange {
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];

      if (start.year == end.year && start.month == end.month) {
        return '${months[start.month - 1]} ${start.day}-${end.day}, ${start.year} | $startTime - $endTime';
      } else {
        return '${months[start.month - 1]} ${start.day}, ${start.year} - ${months[end.month - 1]} ${end.day}, ${end.year} | $startTime - $endTime';
      }
    } catch (e) {
      return '$startDate - $endDate | $startTime - $endTime';
    }
  }

  // Get badge text based on calculated status
  String get badgeText {
    switch (calculatedStatus.toLowerCase()) {
      case 'upcoming':
        return 'Upcoming';
      case 'in progress':
        return 'Ongoing';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'dropped':
        return 'Dropped';
      default:
        return calculatedStatus;
    }
  }

  // Get badge colors based on status (matching training program colors)
  Color get badgeColor {
    switch (calculatedStatus.toLowerCase()) {
      case 'upcoming':
        return const Color(0xFFFFF3E0); // Light orange background
      case 'in progress':
        return const Color(0xFFF3E5F5); // Light purple background
      case 'completed':
        return const Color(0xFFE8F5E8); // Light green background
      case 'cancelled':
        return const Color(0xFFFFEBEE); // Light red background
      case 'dropped':
        return const Color(0xFFFFF3E0); // Light orange background
      default:
        return const Color(0xFFE3F2FD); // Light blue background
    }
  }

  Color get badgeTextColor {
    switch (calculatedStatus.toLowerCase()) {
      case 'upcoming':
        return const Color(0xFFF57C00); // Orange text
      case 'in progress':
        return const Color(0xFF7B1FA2); // Purple text
      case 'completed':
        return const Color(0xFF2E7D32); // Green text
      case 'cancelled':
        return const Color(0xFFD32F2F); // Red text
      case 'dropped':
        return const Color(0xFFF57C00); // Orange text
      default:
        return const Color(0xFF1976D2); // Blue text
    }
  }

  bool get isTrainingComplete => calculatedStatus.toLowerCase() == 'completed';

  // Factory constructor to create from JSON
  factory ScheduleProgram.fromJson(Map<String, dynamic> json) {
    return ScheduleProgram(
      id: json['id'] ?? json['_id'] ?? '',
      programName: json['programName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      enrollmentStartDate: json['enrollmentStartDate'] ?? '',
      enrollmentEndDate: json['enrollmentEndDate'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      instructor: json['instructor'] ?? '',
      venue: json['venue'] ?? '',
      maxParticipants: json['maxParticipants'] ?? 0,
      additionalDetails: json['additionalDetails'] ?? '',
      batch: json['batch'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      duration: json['duration'] ?? 0,
      currentEnrollment: json['currentEnrollment'] ?? 0,
      availableSlots: json['availableSlots'] ?? 0,
      isFull: json['isFull'] ?? false,
      enrollmentPercentage: json['enrollmentPercentage'] ?? 0,
      calculatedStatus: json['calculatedStatus'] ?? json['status'] ?? '',
      sessionMetadata:
          (json['sessionMetadata'] as List?)
              ?.map((session) => SessionMetadata.fromJson(session))
              .toList() ??
          [],
      enrollmentDetails: EnrollmentDetails.fromJson(
        json['enrollmentDetails'] ?? {},
      ),
    );
  }
}

class SessionMetadata {
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final String reason;
  final bool completed;
  final String updatedBy;
  final String updatedAt;
  final String id;

  const SessionMetadata({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.reason,
    required this.completed,
    required this.updatedBy,
    required this.updatedAt,
    required this.id,
  });

  factory SessionMetadata.fromJson(Map<String, dynamic> json) {
    return SessionMetadata(
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      status: json['status'] ?? '',
      reason: json['reason'] ?? '',
      completed: json['completed'] ?? false,
      updatedBy: json['updatedBy'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      id: json['id'] ?? json['_id'] ?? '',
    );
  }
}

class EnrollmentDetails {
  final String? enrolledAt;
  final String status;
  final String? completionDate;
  final bool certificateIssued;

  const EnrollmentDetails({
    this.enrolledAt,
    required this.status,
    this.completionDate,
    required this.certificateIssued,
  });

  factory EnrollmentDetails.fromJson(Map<String, dynamic> json) {
    return EnrollmentDetails(
      enrolledAt: json['enrolledAt'],
      status: json['status'] ?? '',
      completionDate: json['completionDate'],
      certificateIssued: json['certificateIssued'] ?? false,
    );
  }
}
