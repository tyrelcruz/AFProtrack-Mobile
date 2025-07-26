import 'package:flutter/material.dart';

class TrainingProgram {
  final String title;
  final String duration;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;
  final bool isDisabled;
  final String batch;
  final String instructor;
  final String laboratory;
  final String participants;
  final String enrollmentDate;
  final bool isEnrollmentActive;

  const TrainingProgram({
    required this.title,
    required this.duration,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.isDisabled,
    required this.batch,
    required this.instructor,
    required this.laboratory,
    required this.participants,
    required this.enrollmentDate,
    required this.isEnrollmentActive,
  });
}
