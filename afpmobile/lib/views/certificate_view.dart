import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/certificate_card.dart';
import '../widgets/upload_certificate_widget.dart';
import '../widgets/upload_certificate_dialog.dart';
import '../widgets/certificate_filter_button.dart';
import '../models/certificate.dart';
import '../utils/app_colors.dart';

class CertificateView extends StatefulWidget {
  const CertificateView({Key? key}) : super(key: key);

  @override
  State<CertificateView> createState() => _CertificateViewState();
}

class _CertificateViewState extends State<CertificateView> {
  int _currentIndex = 0;

  // Sample certificate data based on the image
  final List<Certificate> _allCertificates = [
    Certificate(
      title: 'Advanced Combat Training',
      instructor: 'Lt. Garcia',
      certificateNumber: 'ACT-2024-01234',
      grade: 'A+',
      status: 'Pending',
    ),
    Certificate(
      title: 'Leadership Development Course',
      instructor: 'Col. Santos',
      certificateNumber: 'LDC-2024-01234',
      grade: 'A+',
      status: 'Approved',
    ),
    Certificate(
      title: 'Cybersecurity Training',
      instructor: 'SSG. Ramirez',
      certificateNumber: 'CST-2024-01234',
      grade: 'B+',
      status: 'Pending',
    ),
  ];

  List<Certificate> get _filteredCertificates {
    switch (_currentIndex) {
      case 0: // My Certificates (all)
        return _allCertificates;
      case 1: // Pending
        return _allCertificates
            .where((cert) => cert.status == 'Pending')
            .toList();
      case 2: // Approved
        return _allCertificates
            .where((cert) => cert.status == 'Approved')
            .toList();
      default:
        return _allCertificates;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const AppBarWidget(title: 'Certificates', showLeading: false),
      body: Column(
        children: [
          // Filter Bar (Fixed)
          Container(
            color: AppColors.appBackground,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width < 360 ? 12 : 16,
              vertical: MediaQuery.of(context).size.width < 360 ? 8 : 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CertificateFilterButton(
                    text: 'My Certificates',
                    isSelected: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width < 360 ? 6 : 8,
                ),
                Expanded(
                  child: CertificateFilterButton(
                    text: 'Pending',
                    isSelected: _currentIndex == 1,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width < 360 ? 6 : 8,
                ),
                Expanded(
                  child: CertificateFilterButton(
                    text: 'Approved',
                    isSelected: _currentIndex == 2,
                    onTap: () => setState(() => _currentIndex = 2),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Content (Upload Certificate + Certificates List)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Upload Certificate Section
                  UploadCertificateWidget(onUpload: () => _showUploadDialog()),

                  // Certificates List
                  _filteredCertificates.isEmpty
                      ? _buildEmptyState()
                      : Column(
                        children:
                            _filteredCertificates.map((certificate) {
                              return CertificateCard(
                                certificate: certificate,
                                onViewDetails:
                                    () => _showCertificateDetails(certificate),
                              );
                            }).toList(),
                      ),

                  // Bottom padding
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    switch (_currentIndex) {
      case 0:
        message = 'No certificates found';
        icon = Icons.verified_outlined;
        break;
      case 1:
        message = 'No pending certificates';
        icon = Icons.pending_outlined;
        break;
      case 2:
        message = 'No approved certificates';
        icon = Icons.check_circle_outline;
        break;
      default:
        message = 'No certificates found';
        icon = Icons.verified_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder:
          (context) => UploadCertificateDialog(
            onTakePhoto: () {
              Navigator.of(context).pop();
              // TODO: Implement camera functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Camera functionality coming soon'),
                ),
              );
            },
            onBrowseFiles: () {
              Navigator.of(context).pop();
              // TODO: Implement file picker functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('File picker functionality coming soon'),
                ),
              );
            },
          ),
    );
  }

  void _showCertificateDetails(Certificate certificate) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(certificate.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Instructor: ${certificate.instructor}'),
                const SizedBox(height: 8),
                Text('Certificate No.: ${certificate.certificateNumber}'),
                const SizedBox(height: 8),
                Text('Grade: ${certificate.grade}'),
                const SizedBox(height: 8),
                Text('Status: ${certificate.status}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
