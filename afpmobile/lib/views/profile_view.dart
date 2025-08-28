import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';
import '../models/user_profile.dart';
import '../services/token_service.dart';
import '../services/profile_service.dart';
import 'login_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profile = await ProfileService.getCurrentUserProfile();

      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
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
              ? const Center(child: CircularProgressIndicator())
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
          GestureDetector(
            onTap: _showProfilePictureDialog,
            child: Container(
              width: profilePictureSize,
              height: profilePictureSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.person,
                size: profileIconSize,
                color: Colors.white,
              ),
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
                _buildHeaderMeta('UNIT:', _userProfile!.unit),
                _buildHeaderMeta('BRANCH', _userProfile!.branch),
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
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
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
            // Overview rows
            _buildOverviewRow('Home Address', _userProfile!.homeAddress),
            _buildOverviewRow('Email', _userProfile!.email),
            if ((_userProfile!.alternateEmail ?? '').isNotEmpty)
              _buildOverviewRow(
                'Alternate Email',
                _userProfile!.alternateEmail ?? '',
              ),
            _buildOverviewRow('Phone', _userProfile!.phone),
            _buildOverviewRow('Date Enlisted', _userProfile!.dateEnlisted),
            _buildOverviewRow('Blood Type', _userProfile!.bloodType ?? '-'),
            _buildOverviewRow('Status', _userProfile!.maritalStatus ?? '-'),
            _buildOverviewRow(
              'Height',
              (_userProfile!.heightMeters ?? '-') + ' m',
            ),
            _buildOverviewRow(
              'Weight',
              (_userProfile!.weightKg ?? '-') + ' kg',
            ),
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

  void _showProfilePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement camera functionality
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement gallery picker functionality
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
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
