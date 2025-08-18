import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ScheduleDetailsModal extends StatelessWidget {
  final String title;
  final String dateTimeRange;
  final String badge;
  final String instructor;
  final String location;
  final bool trainingComplete;

  const ScheduleDetailsModal({
    Key? key,
    required this.title,
    required this.dateTimeRange,
    required this.badge,
    required this.instructor,
    required this.location,
    required this.trainingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool canCheckIn = !trainingComplete;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.event_available,
                        size: 16,
                        color: Color(0xFF3E503A),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Attendance',
                        style: TextStyle(
                          color: Color(0xFF3E503A),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.black, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              dateTimeRange.isEmpty ? 'Completed' : dateTimeRange,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color(0xFF0B6000),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 1),
            _DetailRow(label: 'Instructor', value: instructor),
            const SizedBox(height: 1),
            _DetailRow(label: 'Location', value: location),
            if (trainingComplete) ...[
              const SizedBox(height: 16),
              const Text(
                'Training Complete',
                style: TextStyle(
                  color: Color(0xFF3E503A),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    canCheckIn
                        ? () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Checked in successfully'),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      canCheckIn
                          ? AppColors.trainingButtonPrimary
                          : AppColors.trainingButtonDisabled,
                  foregroundColor:
                      canCheckIn
                          ? AppColors.white
                          : AppColors.trainingButtonDisabledText,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  canCheckIn ? 'Check In' : 'Check In Unavailable',
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
