import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/certificate_card.dart';
import '../widgets/upload_certificate_widget.dart';
import '../widgets/upload_certificate_dialog.dart';
import '../widgets/certificate_filter_button.dart';
import '../models/certificate.dart';
import '../utils/app_colors.dart';
import '../utils/flushbar_utils.dart';
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

        print('🔧 Certificate data from backend:');
        for (var cert in certificatesData) {
          print('   Certificate: $cert');
          if (cert['trainingProgramId'] != null) {
            print(
              '   trainingProgramId type: ${cert['trainingProgramId'].runtimeType}',
            );
            print('   trainingProgramId value: ${cert['trainingProgramId']}');
          }
        }

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
                            // Upload Certificate Section - Always visible
                            UploadCertificateWidget(
                              onUpload: () => _showUploadDialog(),
                            ),

                            // Certificates List or Empty State
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
              FlushbarUtils.showInfo(
                context,
                message: 'Camera functionality coming soon',
              );
            },
            onBrowseFiles: () {
              Navigator.of(context).pop();
              // TODO: Implement file picker functionality
              FlushbarUtils.showInfo(
                context,
                message: 'File picker functionality coming soon',
              );
            },
            onSubmit: (certificateData) async {
              await _uploadCertificate(certificateData);
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
    );
  }

  Future<void> _uploadCertificate(Map<String, dynamic> certificateData) async {
    try {
      final userId = await TokenService.getUserId();
      if (userId == null) {
        FlushbarUtils.showError(context, message: 'User not authenticated');
        return;
      }

      // Show loading indicator
      FlushbarUtils.showInfo(
        context,
        message: 'Uploading certificate...',
        duration: const Duration(seconds: 2),
      );

      final result = await ApiService.uploadCertificate(certificateData);

      if (result['success']) {
        if (mounted) {
          FlushbarUtils.showSuccess(
            context,
            message: result['message'] ?? 'Certificate uploaded successfully',
          );
        }
        // Reload certificates
        _loadCertificates();
      } else {
        if (mounted) {
          FlushbarUtils.showError(
            context,
            message: result['message'] ?? 'Failed to upload certificate',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        FlushbarUtils.showError(
          context,
          message: 'Error uploading certificate: ${e.toString()}',
        );
      }
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
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
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
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 24,
                          ),
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
                            certificate.certificateTitle.isNotEmpty
                                ? certificate.certificateTitle
                                : certificate.description.isNotEmpty
                                ? certificate.description
                                : 'Untitled Certificate',
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
                            color: _getStatusColor(
                              certificate.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            certificate.status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(certificate.status),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Certificate Image
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.grey.shade50,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          certificate.cloudinaryUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey.shade100,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF4CAF50),
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Image not available',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Certificate Details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Certificate Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Training Program
                          if (certificate.trainingProgramName != null &&
                              certificate.trainingProgramName!.isNotEmpty)
                            _buildDetailRow(
                              'Training Program',
                              certificate.trainingProgramName!,
                            ),

                          // Instructor
                          if (certificate.instructor.isNotEmpty)
                            _buildDetailRow(
                              'Instructor',
                              certificate.instructor,
                            ),

                          // Certificate Number
                          if (certificate.certificateNumber.isNotEmpty)
                            _buildDetailRow(
                              'Certificate Number',
                              certificate.certificateNumber,
                            ),

                          // Date Issued
                          _buildDetailRow(
                            'Date Issued',
                            _formatDate(certificate.dateIssued),
                          ),

                          // Grade
                          if (certificate.grade.isNotEmpty)
                            _buildDetailRow('Grade', certificate.grade),

                          // Description
                          if (certificate.description.isNotEmpty)
                            _buildDetailRow(
                              'Description',
                              certificate.description,
                            ),
                        ],
                      ),
                    ),

                    // Review Information
                    if (certificate.reviewedBy != null ||
                        (certificate.reviewNotes != null &&
                            certificate.reviewNotes!.isNotEmpty)) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Review Information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            if (certificate.reviewedBy != null)
                              _buildDetailRow(
                                'Reviewed By',
                                certificate.reviewedBy!.fullName,
                              ),

                            if (certificate.reviewNotes != null &&
                                certificate.reviewNotes!.isNotEmpty)
                              _buildDetailRow(
                                'Review Notes',
                                certificate.reviewNotes!,
                              ),
                          ],
                        ),
                      ),
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
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.3,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: true,
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
