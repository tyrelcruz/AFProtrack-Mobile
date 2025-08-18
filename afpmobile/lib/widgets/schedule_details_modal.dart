import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ScheduleDetailsModal extends StatefulWidget {
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
  State<ScheduleDetailsModal> createState() => _ScheduleDetailsModalState();
}

class _ScheduleDetailsModalState extends State<ScheduleDetailsModal> {
  bool _isCheckedIn = false;
  String? _checkInTimestamp;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool canCheckIn = !widget.trainingComplete && !_isCheckedIn;

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
              widget.dateTimeRange.isEmpty ? 'Completed' : widget.dateTimeRange,
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
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 1),
            _DetailRow(label: 'Instructor', value: widget.instructor),
            const SizedBox(height: 1),
            _DetailRow(label: 'Location', value: widget.location),
            if (widget.trainingComplete) ...[
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

            // Check-in status display
            if (_isCheckedIn) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF4CAF50), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF4CAF50),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Checked In',
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (_checkInTimestamp != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Time: $_checkInTimestamp',
                              style: const TextStyle(
                                color: Color(0xFF4CAF50),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: canCheckIn && !_isLoading ? _handleCheckIn : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isCheckedIn
                          ? AppColors.trainingButtonDisabled
                          : (canCheckIn
                              ? AppColors.trainingButtonPrimary
                              : AppColors.trainingButtonDisabled),
                  foregroundColor:
                      _isCheckedIn
                          ? AppColors.trainingButtonDisabledText
                          : (canCheckIn
                              ? AppColors.white
                              : AppColors.trainingButtonDisabledText),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : Text(
                          _isCheckedIn
                              ? 'Already Checked In'
                              : (canCheckIn
                                  ? 'Check In'
                                  : 'Check In Unavailable'),
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

  void _handleCheckIn() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Get current timestamp
    final now = DateTime.now();
    final hour12 =
        now.hour == 0 ? 12 : (now.hour > 12 ? now.hour - 12 : now.hour);
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    final timestamp =
        '${hour12.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $ampm';

    setState(() {
      _isCheckedIn = true;
      _checkInTimestamp = timestamp;
      _isLoading = false;
    });

    // Show success message
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
