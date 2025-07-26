import 'package:flutter/material.dart';
import '../models/training_program.dart';
import '../utils/app_colors.dart';

class TrainingDetailsModal extends StatelessWidget {
  final TrainingProgram program;

  const TrainingDetailsModal({Key? key, required this.program})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with badge, duration, and close button
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.trainingUpcomingBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    program.status,
                    style: TextStyle(
                      color: AppColors.trainingUpcomingText,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Duration: ${program.duration}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.black, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              program.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Details
            _DetailRow(label: 'Batch', value: program.batch),
            const SizedBox(height: 12),
            _DetailRow(label: 'Instructor', value: program.instructor),
            const SizedBox(height: 12),
            _DetailRow(label: 'Laboratory', value: program.laboratory),
            const SizedBox(height: 24),

            // Participants
            Text(
              'Participants: ${program.participants}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),

            // Progress bar
            LinearProgressIndicator(
              value: _getProgressValue(program.participants),
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 20),

            // Enrollment date
            Text(
              'Enrollment Starts on ${program.enrollmentDate}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0B6000),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Enroll button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    program.isEnrollmentActive
                        ? () {
                          // TODO: Implement enrollment logic
                          Navigator.of(context).pop();
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      program.isEnrollmentActive
                          ? AppColors.trainingButtonPrimary
                          : AppColors.trainingButtonDisabled,
                  foregroundColor:
                      program.isEnrollmentActive
                          ? AppColors.white
                          : AppColors.trainingButtonDisabledText,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Enroll',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getProgressValue(String participants) {
    final parts = participants.split('/');
    if (parts.length == 2) {
      final current = int.tryParse(parts[0]) ?? 0;
      final total = int.tryParse(parts[1]) ?? 1;
      return current / total;
    }
    return 0.0;
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
