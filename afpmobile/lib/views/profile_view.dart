import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';
import '../models/user_profile.dart';
import '../services/token_service.dart';
import '../services/profile_service.dart';
import '../services/api_service.dart';
import '../widgets/skeleton_loading.dart';
import 'login_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserProfile? _userProfile;
  Map<String, dynamic>? _completeUserData;
  bool _isLoading = true;
  String? _errorMessage;
  String? _profilePhotoUrl;
  bool _isLoadingProfilePhoto = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _fetchProfilePhoto();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load both the profile and complete user data
      final profile = await ProfileService.getCurrentUserProfile();
      final completeData = await ApiService.getCompleteUserDetails();

      if (mounted) {
        setState(() {
          _userProfile = profile;
          _completeUserData =
              completeData['success'] ? completeData['data'] : null;
          _isLoading = false;
        });
        // Refresh profile photo after loading profile
        _fetchProfilePhoto();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load profile: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchProfilePhoto() async {
    setState(() {
      _isLoadingProfilePhoto = true;
    });

    try {
      print('👤 Profile: Fetching user profile photo...');
      final result = await ApiService.getUserProfilePhoto();

      print('👤 Profile: Profile photo result: $result');

      if (result['success']) {
        if (result['data'] != null) {
          final photoData = result['data'];
          print('👤 Profile: Photo data received: $photoData');

          if (photoData['cloudinaryUrl'] != null) {
            final photoUrl = photoData['cloudinaryUrl'];
            print('👤 Profile: Setting profile photo URL: $photoUrl');
            setState(() {
              _profilePhotoUrl = photoUrl;
              _isLoadingProfilePhoto = false;
            });
          } else {
            print('👤 Profile: No photo URL found in response data');
            setState(() {
              _profilePhotoUrl = null; // Clear the photo URL
              _isLoadingProfilePhoto = false;
            });
          }
        } else {
          print('👤 Profile: No profile photo found for user');
          setState(() {
            _profilePhotoUrl = null; // Clear the photo URL
            _isLoadingProfilePhoto = false;
          });
        }
      } else {
        print(
          '👤 Profile: Failed to fetch profile photo: ${result['message']}',
        );
        setState(() {
          _profilePhotoUrl = null; // Clear the photo URL on error
          _isLoadingProfilePhoto = false;
        });
      }
    } catch (e) {
      print('👤 Profile: Error fetching profile photo: ${e.toString()}');
      setState(() {
        _profilePhotoUrl = null; // Clear the photo URL on error
        _isLoadingProfilePhoto = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive dimensions
    final cardWidth =
        ResponsiveUtils.isMobile(context)
            ? screenWidth * 0.95
            : ResponsiveUtils.isTablet(context)
            ? screenWidth * 0.8
            : 400.0;

    final profilePictureSize = ResponsiveUtils.isMobile(context) ? 65.0 : 75.0;
    final profileIconSize = ResponsiveUtils.isMobile(context) ? 38.0 : 43.0;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: AppColors.armyPrimary,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        title: const Text(
          'TRAINEE PROFILE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Edit icon on the right
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: _userProfile != null ? _showEditProfileDialog : null,
          ),
        ],
      ),

      body:
          _isLoading
              ? const ProfileViewSkeleton()
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadUserProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : _userProfile == null
              ? const Center(
                child: Text(
                  'No profile data available',
                  style: TextStyle(fontSize: 16),
                ),
              )
              : Stack(
                children: [
                  // Top header background
                  Container(
                    height: ResponsiveUtils.isMobile(context) ? 480 : 440,
                    width: double.infinity,
                    color: AppColors.armyPrimary,
                  ),
                  // Content without scrolling
                  Column(
                    children: [
                      // Header content
                      _buildHeaderSection(
                        context,
                        profilePictureSize: profilePictureSize,
                        profileIconSize: profileIconSize,
                      ),
                      const SizedBox(height: 5),
                      // Overview card with rounded top corners - expanded to fill remaining space
                      Expanded(child: _buildOverviewCard(context, cardWidth)),
                    ],
                  ),
                ],
              ),
    );
  }

  Widget _buildHeaderSection(
    BuildContext context, {
    required double profilePictureSize,
    required double profileIconSize,
  }) {
    if (_userProfile == null) return const SizedBox.shrink();

    final padding = ResponsiveUtils.getResponsivePadding(context);
    final double leftPadding =
        padding + (ResponsiveUtils.isMobile(context) ? 20.0 : 40.0);
    final double topPadding = ResponsiveUtils.isMobile(context) ? 8.0 : 12.0;
    final double rightPadding =
        padding + (ResponsiveUtils.isMobile(context) ? 20.0 : 40.0);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        leftPadding,
        topPadding,
        rightPadding,
        padding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile picture
          Container(
            width: profilePictureSize,
            height: profilePictureSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child:
                _isLoadingProfilePhoto
                    ? Center(
                      child: SizedBox(
                        width: profileIconSize * 0.5,
                        height: profileIconSize * 0.5,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    )
                    : _profilePhotoUrl != null
                    ? ClipOval(
                      child: Image.network(
                        _profilePhotoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: profileIconSize,
                            color: Colors.white,
                          );
                        },
                      ),
                    )
                    : _userProfile?.profilePictureUrl != null
                    ? ClipOval(
                      child: Image.network(
                        _userProfile!.profilePictureUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: profileIconSize,
                            color: Colors.white,
                          );
                        },
                      ),
                    )
                    : Icon(
                      Icons.person,
                      size: profileIconSize,
                      color: Colors.white,
                    ),
          ),
          SizedBox(width: 26),
          // Name and essentials
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userProfile!.name.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildHeaderMeta('AFPIC NO:', _userProfile!.serviceId),
                _buildHeaderMeta(
                  'UNIT:',
                  _completeUserData?['unit'] ?? _userProfile!.unit,
                ),
                _buildHeaderMeta(
                  'BRANCH:',
                  _completeUserData?['branchOfService'] ?? _userProfile!.branch,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderMeta(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label  ',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context, double cardWidth) {
    if (_userProfile == null) return const SizedBox.shrink();

    final basePadding = ResponsiveUtils.getResponsivePadding(context);
    final double horizontalPadding =
        basePadding + (ResponsiveUtils.isMobile(context) ? 8.0 : 16.0);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          20,
          horizontalPadding,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'PROFILE OVERVIEW',
              style: TextStyle(
                color: AppColors.armyPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            // Most important information only
            if (_completeUserData != null) ...[
              _buildOverviewRow(
                'Service ID',
                _completeUserData!['serviceId'] ?? '-',
              ),
              _buildOverviewRow('Rank', _completeUserData!['rank'] ?? '-'),
              _buildOverviewRow(
                'Branch of Service',
                _completeUserData!['branchOfService'] ?? '-',
              ),
              _buildOverviewRow(
                'Division',
                _completeUserData!['division'] ?? '-',
              ),
              _buildOverviewRow('Unit', _completeUserData!['unit'] ?? '-'),
              _buildOverviewRow('Email', _completeUserData!['email'] ?? '-'),
              _buildOverviewRow(
                'Contact Number',
                _completeUserData!['contactNumber'] ?? '-',
              ),
            ] else ...[
              // Fallback to existing data if complete data not available
              _buildOverviewRow('Email', _userProfile!.email),
              _buildOverviewRow('Phone', _userProfile!.phone),
              _buildOverviewRow('Date Enlisted', _userProfile!.dateEnlisted),
            ],
            const SizedBox(height: 16),
            Container(height: 1, color: Colors.grey[300]),
            const SizedBox(height: 16),
            // Training summary
            Text(
              'TRAINING SUMMARY',
              style: TextStyle(
                color: AppColors.armyPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    'Completed Programs',
                    _userProfile!.completedPrograms.toString(),
                  ),
                ),
                Container(width: 1, height: 48, color: Colors.grey[300]),
                Expanded(
                  child: _buildStatTile(
                    'Certificates Earned',
                    _userProfile!.certificatesEarned.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // View All Information Button
            if (_completeUserData != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showCompleteUserDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.armyPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'View All Information',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Push logout button to bottom
            const Spacer(),
            // Actions
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColors.cardBorder, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.grey[700], size: 20),
                title: const Text('Logout'),
                onTap: _showLogoutDialog,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
      ],
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // Get screen width for responsive design
        final screenWidth = MediaQuery.of(context).size.width;

        // Calculate responsive margins and width
        double horizontalMargin;
        double dialogWidth;

        if (screenWidth < 360) {
          // Small phones
          horizontalMargin = 12;
          dialogWidth = screenWidth - 24;
        } else if (screenWidth < 480) {
          // Medium phones
          horizontalMargin = 16;
          dialogWidth = screenWidth - 32;
        } else if (screenWidth < 600) {
          // Large phones
          horizontalMargin = 20;
          dialogWidth = screenWidth - 40;
        } else {
          // Tablets and larger
          horizontalMargin = 30;
          dialogWidth = 600; // Max width for larger screens
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with settings icon
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 8),
                  child: Icon(
                    Icons.settings,
                    size: 50,
                    color: AppColors.armyPrimary,
                  ),
                ),

                // Title
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth < 360 ? 16 : 20,
                  ),
                  child: Text(
                    'Edit Profile Settings',
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 16 : 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Message
                Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: 20,
                    left: screenWidth < 360 ? 16 : 20,
                    right: screenWidth < 360 ? 16 : 20,
                  ),
                  child: Text(
                    'You can update your personal information, contact details, and profile picture. All changes will be saved automatically.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 13 : 14,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ),

                // Divider
                Container(height: 0.5, color: Colors.grey[300]),

                // Cancel button
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue[600],
                      ),
                    ),
                  ),
                ),

                // Divider
                Container(height: 0.5, color: Colors.grey[300]),

                // Continue button
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    if (_userProfile != null) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  EditProfileView(profile: _userProfile!),
                        ),
                      );
                      if (result != null && result is UserProfile) {
                        setState(() {
                          _userProfile = result;
                        });
                        // Refresh profile data from backend to ensure consistency
                        _loadUserProfile();
                        // Also refresh profile photo to reflect any changes
                        _fetchProfilePhoto();
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.armyPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCompleteUserDetails() {
    if (_completeUserData == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Complete User Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.armyPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailSection('Personal Information', [
                        _buildDetailRow(
                          'Full Name',
                          _completeUserData!['fullName'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Service ID',
                          _completeUserData!['serviceId'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Email',
                          _completeUserData!['email'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Alternate Email',
                          _completeUserData!['alternateEmail'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Contact Number',
                          _completeUserData!['contactNumber'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Date of Birth',
                          _formatDate(_completeUserData!['dateOfBirth']),
                        ),
                        _buildDetailRow(
                          'Address',
                          _completeUserData!['address'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Blood Type',
                          _completeUserData!['bloodType'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Height',
                          '${_completeUserData!['height'] ?? '-'} cm',
                        ),
                        _buildDetailRow(
                          'Weight',
                          '${_completeUserData!['weight'] ?? '-'} kg',
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildDetailSection('Military Information', [
                        _buildDetailRow(
                          'Rank',
                          _completeUserData!['rank'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Branch of Service',
                          _completeUserData!['branchOfService'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Division',
                          _completeUserData!['division'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Unit',
                          _completeUserData!['unit'] ?? '-',
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildDetailSection('Emergency Contact', [
                        _buildDetailRow(
                          'Name',
                          _completeUserData!['emergencyContactName'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Relationship',
                          _completeUserData!['emergencyContactRelationship'] ??
                              '-',
                        ),
                        _buildDetailRow(
                          'Contact Number',
                          _completeUserData!['emergencyContactNumber'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Address',
                          _completeUserData!['emergencyContactAddress'] ?? '-',
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildDetailSection('Account Information', [
                        _buildDetailRow(
                          'Role',
                          _completeUserData!['role'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Account Status',
                          _completeUserData!['accountStatus'] ?? '-',
                        ),
                        _buildDetailRow(
                          'Is Active',
                          _completeUserData!['isActive'] == true ? 'Yes' : 'No',
                        ),
                        _buildDetailRow(
                          'Is Verified',
                          _completeUserData!['isVerified'] == true
                              ? 'Yes'
                              : 'No',
                        ),
                        _buildDetailRow(
                          'Created At',
                          _formatDate(_completeUserData!['createdAt']),
                        ),
                        _buildDetailRow(
                          'Last Login',
                          _formatDate(_completeUserData!['lastLogin']),
                        ),
                      ]),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.armyPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return '-';
    try {
      final date = DateTime.parse(dateValue.toString());
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateValue.toString();
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // Get screen width for responsive design
        final screenWidth = MediaQuery.of(context).size.width;

        // Calculate responsive margins and width
        double horizontalMargin;
        double dialogWidth;

        if (screenWidth < 360) {
          // Small phones
          horizontalMargin = 12;
          dialogWidth = screenWidth - 24;
        } else if (screenWidth < 480) {
          // Medium phones
          horizontalMargin = 16;
          dialogWidth = screenWidth - 32;
        } else if (screenWidth < 600) {
          // Large phones
          horizontalMargin = 20;
          dialogWidth = screenWidth - 40;
        } else {
          // Tablets and larger
          horizontalMargin = 30;
          dialogWidth = 600; // Max width for larger screens
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with warning icon
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 8),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 50,
                    color: Colors.orange[600],
                  ),
                ),

                // Title
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth < 360 ? 16 : 20,
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 16 : 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Message
                Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: 20,
                    left: screenWidth < 360 ? 16 : 20,
                    right: screenWidth < 360 ? 16 : 20,
                  ),
                  child: Text(
                    'Are you sure you want to logout? You will need to sign in again to access your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 13 : 14,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ),

                // Divider
                Container(height: 0.5, color: Colors.grey[300]),

                // Cancel button
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue[600],
                      ),
                    ),
                  ),
                ),

                // Divider
                Container(height: 0.5, color: Colors.grey[300]),

                // Logout button
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    _performLogout();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Logout',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performLogout() async {
    // Clear authentication data
    await TokenService.clearAuthData();

    // Navigate to login screen and clear the entire navigation stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false, // This removes all previous routes
    );
  }
}
