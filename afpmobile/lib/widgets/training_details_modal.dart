import 'package:flutter/material.dart';
import '../models/training_program.dart';
import '../utils/app_colors.dart';
import '../utils/flushbar_utils.dart';
import '../services/api_service.dart';
import '../services/training_data_service.dart';

class TrainingDetailsModal extends StatefulWidget {
  final TrainingProgram program;

  const TrainingDetailsModal({Key? key, required this.program})
    : super(key: key);

  @override
  State<TrainingDetailsModal> createState() => _TrainingDetailsModalState();
}

class _TrainingDetailsModalState extends State<TrainingDetailsModal> {
  bool _isEnrolling = false;
  String? _enrollmentError;

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
            // Header with close button
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.black, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title with status badge on the right
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.program.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: widget.program.statusColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.program.displayStatus,
                    style: TextStyle(
                      color: widget.program.statusTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Details
            _DetailRow(label: 'Batch', value: widget.program.batch),
            const SizedBox(height: 12),
            _DetailRow(label: 'Instructor', value: widget.program.instructor),
            const SizedBox(height: 12),
            _DetailRow(label: 'Venue', value: widget.program.venue),
            const SizedBox(height: 12),
            _DetailRow(
              label: 'Time',
              value:
                  '${widget.program.formattedStartTime} - ${widget.program.formattedEndTime}',
            ),
            const SizedBox(height: 24),

            // Participants
            Text(
              'Participants: ${widget.program.participants}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),

            // Progress bar
            LinearProgressIndicator(
              value: _getProgressValue(widget.program.participants),
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 20),

            // Enrollment date
            Text(
              'Enrollment Starts on ${widget.program.enrollmentDate}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0B6000),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Error message
            if (_enrollmentError != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _enrollmentError!,
                        style: TextStyle(color: Colors.red[700], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),

            // Action button (Enroll/View Details/etc.)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    _isEnrolling ||
                            widget.program.isDisabled ||
                            widget.program.isEnrolled
                        ? null
                        : _handleEnrollment,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isEnrolling || widget.program.isEnrolled
                          ? AppColors.trainingButtonDisabled
                          : widget.program.buttonColor,
                  foregroundColor:
                      _isEnrolling || widget.program.isEnrolled
                          ? AppColors.trainingButtonDisabledText
                          : widget.program.buttonTextColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isEnrolling
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : Text(
                          widget.program.isEnrolled
                              ? 'Currently Enrolled'
                              : _getModalButtonText(),
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

  String _getModalButtonText() {
    switch (widget.program.status.toLowerCase()) {
      case 'completed':
        return 'View Certificate';
      case 'in progress':
        return 'Currently Active';
      case 'available':
      case 'upcoming':
        return 'Enroll';
      default:
        return 'View Details';
    }
  }

  Future<void> _handleEnrollment() async {
    setState(() {
      _isEnrolling = true;
      _enrollmentError = null;
    });

    try {
      final response = await ApiService.enrollInTrainingProgram(
        widget.program.id,
      );

      if (response['success']) {
        // Clear cache to refresh training list
        TrainingDataService.clearCache();

        // Show success message and close modal
        if (mounted) {
          FlushbarUtils.showSuccess(
            context,
            title: 'Enrollment Successful',
            message:
                response['message'] ??
                'Successfully enrolled in training program!',
            duration: const Duration(seconds: 3),
          );
          Navigator.of(context).pop();
        }
      } else {
        // Show error message
        setState(() {
          _enrollmentError =
              response['message'] ?? 'Failed to enroll in training program';
        });
      }
    } catch (e) {
      setState(() {
        _enrollmentError = 'Network error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isEnrolling = false;
        });
      }
    }
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
