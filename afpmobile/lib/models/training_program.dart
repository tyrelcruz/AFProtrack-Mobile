import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TrainingProgram {
  final String id;
  final String programName;
  final String startDate;
  final String endDate;
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
  final String durationDisplay;
  final int currentEnrollment;
  final int availableSlots;
  final bool isFull;
  final int enrollmentPercentage;
  final bool isEnrolled;

  // Computed properties for UI compatibility
  String get title => programName;
  String get participants => '$currentEnrollment/$maxParticipants';

  // Format enrollment date for display
  String get enrollmentDate {
    try {
      final date = DateTime.parse(startDate);
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
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return startDate;
    }
  }

  // Format start date for display
  String get formattedStartDate {
    try {
      final date = DateTime.parse(startDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return startDate;
    }
  }

  // Format end date for display
  String get formattedEndDate {
    try {
      final date = DateTime.parse(endDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return endDate;
    }
  }

  // Format start time to 24-hour format
  String get formattedStartTime {
    try {
      final time = startTime;
      if (time.contains('AM') || time.contains('PM')) {
        // Convert 12-hour format to 24-hour format
        final hour = int.parse(time.split(':')[0]);
        final minute = int.parse(time.split(':')[1].split(' ')[0]);
        final period = time.split(' ')[1];

        int hour24 = hour;
        if (period == 'PM' && hour != 12) {
          hour24 = hour + 12;
        } else if (period == 'AM' && hour == 12) {
          hour24 = 0;
        }

        return '${hour24.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      }
      return time; // Already in 24-hour format
    } catch (e) {
      return startTime;
    }
  }

  // Format end time to 24-hour format
  String get formattedEndTime {
    try {
      final time = endTime;
      if (time.contains('AM') || time.contains('PM')) {
        // Convert 12-hour format to 24-hour format
        final hour = int.parse(time.split(':')[0]);
        final minute = int.parse(time.split(':')[1].split(' ')[0]);
        final period = time.split(' ')[1];

        int hour24 = hour;
        if (period == 'PM' && hour != 12) {
          hour24 = hour + 12;
        } else if (period == 'AM' && hour == 12) {
          hour24 = 0;
        }

        return '${hour24.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      }
      return time; // Already in 24-hour format
    } catch (e) {
      return endTime;
    }
  }

  bool get isEnrollmentActive => !isFull && status == 'available';

  // Status colors based on status
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'available':
        return AppColors.trainingAvailableBg;
      case 'ongoing':
        return AppColors.trainingInProgressBg;
      case 'upcoming':
        return AppColors.trainingUpcomingBg;
      case 'completed':
        return AppColors.trainingCompletedBg;
      default:
        return AppColors.trainingAvailableBg;
    }
  }

  Color get statusTextColor {
    switch (status.toLowerCase()) {
      case 'available':
        return AppColors.trainingAvailableText;
      case 'ongoing':
        return AppColors.trainingInProgressText;
      case 'upcoming':
        return AppColors.trainingUpcomingText;
      case 'completed':
        return AppColors.trainingCompletedText;
      default:
        return AppColors.trainingAvailableText;
    }
  }

  String get buttonText {
    if (isEnrolled) {
      return 'Currently Enrolled';
    }
    switch (status.toLowerCase()) {
      case 'completed':
        return 'View Certificate';
      case 'ongoing':
        return 'Currently Active';
      default:
        return 'View Training Details';
    }
  }

  Color get buttonColor {
    if (isEnrolled || status.toLowerCase() == 'ongoing') {
      return AppColors.trainingButtonDisabled;
    }
    if (status.toLowerCase() == 'completed') {
      return AppColors.trainingButtonSecondary;
    }
    return AppColors.trainingButtonPrimary;
  }

  Color get buttonTextColor {
    if (isEnrolled || status.toLowerCase() == 'ongoing') {
      return AppColors.trainingButtonDisabledText;
    }
    return AppColors.white;
  }

  bool get isDisabled {
    return isEnrolled ||
        status.toLowerCase() == 'ongoing' ||
        status.toLowerCase() == 'completed';
  }

  const TrainingProgram({
    required this.id,
    required this.programName,
    required this.startDate,
    required this.endDate,
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
    required this.durationDisplay,
    required this.currentEnrollment,
    required this.availableSlots,
    required this.isFull,
    required this.enrollmentPercentage,
    required this.isEnrolled,
  });

  // Factory constructor to create from JSON
  factory TrainingProgram.fromJson(Map<String, dynamic> json) {
    final status = json['status'] ?? '';
    print('=== DEBUG: Creating TrainingProgram from JSON ===');
    print('Program: ${json['programName']}, Raw Status: "$status"');

    final program = TrainingProgram(
      id: json['id'] ?? json['_id'] ?? '',
      programName: json['programName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      instructor: json['instructor'] ?? '',
      venue: json['venue'] ?? '',
      maxParticipants: json['maxParticipants'] ?? 0,
      additionalDetails: json['additionalDetails'] ?? '',
      batch: json['batch'] ?? '',
      status: status,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      duration: json['duration'] ?? 0,
      durationDisplay: json['durationDisplay'] ?? '',
      currentEnrollment: json['currentEnrollment'] ?? 0,
      availableSlots: json['availableSlots'] ?? 0,
      isFull: json['isFull'] ?? false,
      enrollmentPercentage: json['enrollmentPercentage'] ?? 0,
      isEnrolled: json['isEnrolled'] ?? false,
    );

    print('Created program status: "${program.status}"');
    print('=== END DEBUG ===');

    return program;
  }
}
