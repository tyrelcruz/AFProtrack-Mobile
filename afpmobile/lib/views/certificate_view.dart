import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/certificate_card.dart';
import '../widgets/upload_certificate_widget.dart';
import '../widgets/upload_certificate_dialog.dart';
import '../widgets/certificate_filter_button.dart';
import '../models/certificate.dart';
import '../utils/app_colors.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class CertificateView extends StatefulWidget {
  const CertificateView({Key? key}) : super(key: key);

  @override
  State<CertificateView> createState() => _CertificateViewState();
}

class _CertificateViewState extends State<CertificateView> {
  int _currentIndex = 0;
  bool _isLoading = true;
  String? _errorMessage;
  List<Certificate> _allCertificates = [];

  @override
  void initState() {
    super.initState();
    _loadCertificates();
  }

  Future<void> _loadCertificates() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = await TokenService.getUserId();
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User not authenticated';
        });
        return;
      }

      final result = await ApiService.getUserCertificates(userId);

      if (result['success']) {
        final List<dynamic> certificatesData = result['data'] ?? [];
        final certificates =
            certificatesData.map((json) => Certificate.fromJson(json)).toList();

        setState(() {
          _allCertificates = certificates;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = result['message'] ?? 'Failed to load certificates';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading certificates: ${e.toString()}';
      });
    }
  }

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
            child:
                _isLoading
                    ? _buildLoadingState()
                    : _errorMessage != null
                    ? _buildErrorState()
                    : RefreshIndicator(
                      onRefresh: _loadCertificates,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Upload Certificate Section
                            UploadCertificateWidget(
                              onUpload: () => _showUploadDialog(),
                            ),

                            // Certificates List
                            _filteredCertificates.isEmpty
                                ? _buildEmptyState()
                                : Column(
                                  children:
                                      _filteredCertificates.map((certificate) {
                                        return CertificateCard(
                                          certificate: certificate,
                                          onViewDetails:
                                              () => _showCertificateDetails(
                                                certificate,
                                              ),
                                        );
                                      }).toList(),
                                ),

                            // Bottom padding
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading certificates...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'An error occurred',
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadCertificates,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.armyPrimary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
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
            onSubmit: (certificateData) async {
              Navigator.of(context).pop();
              await _uploadCertificate(certificateData);
            },
          ),
    );
  }

  Future<void> _uploadCertificate(Map<String, String> certificateData) async {
    try {
      final userId = await TokenService.getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Uploading certificate...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Prepare the certificate data for the API
      final apiData = {
        'userId': userId,
        'description': certificateData['title'] ?? '',
        'fileName': 'certificate.pdf', // This would come from file picker
        'fileType': 'pdf', // This would be determined from the file
        'fileSize': 1024000, // This would come from the actual file
      };

      final result = await ApiService.uploadCertificate(userId, apiData);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Certificate uploaded successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Reload certificates
        _loadCertificates();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to upload certificate'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading certificate: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCertificateDetails(Certificate certificate) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with status badge and close button
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            certificate.status,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          certificate.status,
                          style: TextStyle(
                            color: _getStatusColor(certificate.status),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    certificate.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Details
                  _buildDetailRow('File Name', certificate.fileName),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'File Type',
                    certificate.fileType.toUpperCase(),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('File Size', certificate.formattedFileSize),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Submitted',
                    _formatDate(certificate.submittedAt),
                  ),
                  if (certificate.reviewedBy != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Reviewed By',
                      certificate.reviewedBy!.fullName,
                    ),
                  ],
                  if (certificate.reviewNotes != null &&
                      certificate.reviewNotes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow('Review Notes', certificate.reviewNotes!),
                  ],
                  const SizedBox(height: 24),

                  // Close button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.armyPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
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
