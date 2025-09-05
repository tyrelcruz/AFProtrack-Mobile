import 'package:flutter/material.dart';
import '../models/certificate.dart';
import '../utils/app_colors.dart';

class CertificateCard extends StatelessWidget {
  final Certificate certificate;
  final VoidCallback? onViewDetails;

  const CertificateCard({
    Key? key,
    required this.certificate,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with title and status
            Row(
              children: [
                Expanded(
                  child: Text(
                    certificate.certificateTitle.isNotEmpty
                        ? certificate.certificateTitle
                        : certificate.description.isNotEmpty
                        ? certificate.description
                        : 'Untitled Certificate',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(certificate.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    certificate.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(certificate.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Certificate Details
            // Training Program
            if (certificate.trainingProgramName != null &&
                certificate.trainingProgramName!.isNotEmpty)
              _buildInfoRow(
                'Training Program',
                certificate.trainingProgramName!,
              ),

            // Instructor
            if (certificate.instructor.isNotEmpty)
              _buildInfoRow('Instructor', certificate.instructor),

            // Certificate Number
            if (certificate.certificateNumber.isNotEmpty)
              _buildInfoRow(
                'Certificate Number',
                certificate.certificateNumber,
              ),

            // Date Issued
            _buildInfoRow('Date Issued', _formatDate(certificate.dateIssued)),

            // Grade
            if (certificate.grade.isNotEmpty)
              _buildInfoRow('Grade', certificate.grade),

            // Description
            if (certificate.description.isNotEmpty)
              _buildInfoRow('Description', certificate.description),
            const SizedBox(height: 12),
            // Bottom row with submission date and view details button
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _formatDate(certificate.submittedAt),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onViewDetails,
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.trainingButtonPrimary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
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
  }
}
