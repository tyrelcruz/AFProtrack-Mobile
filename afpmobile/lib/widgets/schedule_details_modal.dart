import 'package:flutter/material.dart';
import '../models/schedule_program.dart';

class ScheduleDetailsModal extends StatefulWidget {
  final String title;
  final String dateTimeRange;
  final String badge;
  final String instructor;
  final String location;
  final bool trainingComplete;
  final List<SessionMetadata> sessionMetadata;

  const ScheduleDetailsModal({
    Key? key,
    required this.title,
    required this.dateTimeRange,
    required this.badge,
    required this.instructor,
    required this.location,
    required this.trainingComplete,
    this.sessionMetadata = const [],
  }) : super(key: key);

  @override
  State<ScheduleDetailsModal> createState() => _ScheduleDetailsModalState();
}

class _ScheduleDetailsModalState extends State<ScheduleDetailsModal> {
  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 1),
            _DetailRow(label: 'Status', value: widget.badge),
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

            // Show cancellation information if there are cancelled sessions
            if (widget.sessionMetadata.any(
              (session) => session.status.toLowerCase() == 'cancelled',
            )) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange[700],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Cancelled Sessions',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[700],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...widget.sessionMetadata
                        .where(
                          (session) =>
                              session.status.toLowerCase() == 'cancelled',
                        )
                        .map((session) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.orange[100]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.event_busy,
                                        color: Colors.orange[600],
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _formatSessionDate(session.date),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange[700],
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${session.startTime} - ${session.endTime}',
                                        style: TextStyle(
                                          color: Colors.orange[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (session.reason.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Reason: ${session.reason}',
                                      style: TextStyle(
                                        color: Colors.orange[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatSessionDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
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
