import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/bottom_nav_bar.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive dimensions
    final cardWidth =
        ResponsiveUtils.isMobile(context)
            ? screenWidth * 0.95
            : ResponsiveUtils.isTablet(context)
            ? screenWidth * 0.8
            : 400.0;

    final profileCardHeight =
        ResponsiveUtils.isMobile(context)
            ? screenHeight * 0.68
            : ResponsiveUtils.isTablet(context)
            ? screenHeight * 0.65
            : 588.0;

    final trainingCardHeight =
        ResponsiveUtils.isMobile(context)
            ? screenHeight * 0.15
            : ResponsiveUtils.isTablet(context)
            ? screenHeight * 0.12
            : 143.0;

    final padding = ResponsiveUtils.getResponsivePadding(context);
    final profilePictureSize = ResponsiveUtils.isMobile(context) ? 65.0 : 75.0;
    final profileIconSize = ResponsiveUtils.isMobile(context) ? 38.0 : 43.0;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const AppBarWidget(
        title: 'Profile',
        showLeading: true, // Shows back button
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 1 : 2),
            // Profile container
            Container(
              width: cardWidth,
              height: profileCardHeight,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.cardBorder, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    children: [
                      // Profile Header Section
                      Column(
                        children: [
                          // Profile Picture - Placeholder that can be changed
                          GestureDetector(
                            onTap: () {
                              // TODO: Implement profile picture change functionality
                              _showProfilePictureDialog();
                            },
                            child: Container(
                              width: profilePictureSize,
                              height: profilePictureSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.black,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                size: profileIconSize,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveUtils.isMobile(context) ? 12 : 14,
                          ),
                          // Name
                          Text(
                            'Juan Dela Cruz',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                mobile: 22,
                                tablet: 22,
                                desktop: 22,
                              ),
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveUtils.isMobile(context) ? 2 : 2,
                          ),
                          // Rank
                          Text(
                            'Sergeant (SGT)',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                mobile: 15,
                                tablet: 15,
                                desktop: 15,
                              ),
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveUtils.isMobile(context) ? 3 : 3,
                          ),
                          // ID
                          Text(
                            'AFP - 001234',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getResponsiveFontSize(
                                context,
                                mobile: 15,
                                tablet: 15,
                                desktop: 15,
                              ),
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: ResponsiveUtils.isMobile(context) ? 18 : 18,
                      ),

                      // Information Cards
                      _buildInfoCard(
                        context,
                        icon: Icons.shield,
                        title: 'Special Forces Regiment',
                        detail: 'Philippine Army',
                      ),
                      SizedBox(
                        height: ResponsiveUtils.isMobile(context) ? 5 : 5,
                      ),
                      _buildInfoCard(
                        context,
                        icon: Icons.location_on,
                        title: 'Current Base',
                        detail: 'Fort Bonifacio, Taguig',
                      ),
                      SizedBox(
                        height: ResponsiveUtils.isMobile(context) ? 12 : 12,
                      ),
                      _buildInfoCard(
                        context,
                        icon: Icons.email,
                        title: 'Email',
                        detail: 'j.delacruz@afp.mil.ph',
                      ),
                      SizedBox(
                        height: ResponsiveUtils.isMobile(context) ? 12 : 12,
                      ),
                      _buildInfoCard(
                        context,
                        icon: Icons.phone,
                        title: 'Phone',
                        detail: '(+63) 912-345-6789',
                      ),
                      SizedBox(
                        height: ResponsiveUtils.isMobile(context) ? 12 : 12,
                      ),
                      _buildInfoCard(
                        context,
                        icon: Icons.calendar_today,
                        title: 'Date Enlisted',
                        detail: 'February 15, 2020',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //training summary
            Container(
              width: cardWidth,
              height: trainingCardHeight,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.cardBorder, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.getResponsivePadding(
                      context,
                      mobile: 12,
                      tablet: 16,
                      desktop: 16,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Training Summary',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            mobile: 18,
                            tablet: 18,
                            desktop: 18,
                          ),
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUtils.isMobile(context) ? 8 : 8,
                      ),
                      // Divider line
                      Container(height: 1, color: Colors.grey[300]),
                      SizedBox(
                        height: ResponsiveUtils.isMobile(context) ? 12 : 12,
                      ),
                      // Stats section
                      Expanded(
                        child: Row(
                          children: [
                            // Left section - Completed Programs
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '8',
                                    style: TextStyle(
                                      fontSize:
                                          ResponsiveUtils.getResponsiveFontSize(
                                            context,
                                            mobile: 24,
                                            tablet: 24,
                                            desktop: 24,
                                          ),
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        ResponsiveUtils.isMobile(context)
                                            ? 1
                                            : 1,
                                  ),
                                  Text(
                                    'Completed Programs',
                                    style: TextStyle(
                                      fontSize:
                                          ResponsiveUtils.getResponsiveFontSize(
                                            context,
                                            mobile: 14,
                                            tablet: 14,
                                            desktop: 14,
                                          ),
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            // Vertical divider
                            Container(
                              width: 1,
                              height:
                                  ResponsiveUtils.isMobile(context) ? 50 : 60,
                              color: Colors.grey[300],
                            ),
                            // Right section - Certificates Earned
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '12',
                                    style: TextStyle(
                                      fontSize:
                                          ResponsiveUtils.getResponsiveFontSize(
                                            context,
                                            mobile: 24,
                                            tablet: 24,
                                            desktop: 24,
                                          ),
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        ResponsiveUtils.isMobile(context)
                                            ? 1
                                            : 1,
                                  ),
                                  Text(
                                    'Certificates Earned',
                                    style: TextStyle(
                                      fontSize:
                                          ResponsiveUtils.getResponsiveFontSize(
                                            context,
                                            mobile: 14,
                                            tablet: 14,
                                            desktop: 14,
                                          ),
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: ResponsiveUtils.isMobile(context) ? 16 : 20),

            // Action Buttons
            Container(
              width: cardWidth,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.cardBorder, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                child: Column(
                  children: [
                    // Edit Profile Settings
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: Colors.grey[700],
                        size: ResponsiveUtils.isMobile(context) ? 20 : 22,
                      ),
                      title: Text(
                        'Edit Profile Settings',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            mobile: 16,
                            tablet: 16,
                            desktop: 16,
                          ),
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        _showEditProfileDialog();
                      },
                    ),
                    // Divider
                    Container(
                      height: 1,
                      color: Colors.grey[300],
                      margin: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.isMobile(context) ? 16 : 20,
                      ),
                    ),
                    // Logout
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.grey[700],
                        size: ResponsiveUtils.isMobile(context) ? 20 : 22,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            mobile: 16,
                            tablet: 16,
                            desktop: 16,
                          ),
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        _showLogoutDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // No bottom navigation bar needed since Profile is accessed as a separate page
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.getResponsivePadding(
          context,
          mobile: 14,
          tablet: 16,
          desktop: 16,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: ResponsiveUtils.isMobile(context) ? 22 : 24,
          ),
          SizedBox(width: ResponsiveUtils.isMobile(context) ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      mobile: 16,
                      tablet: 16,
                      desktop: 16,
                    ),
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.isMobile(context) ? 1 : 2),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      mobile: 15,
                      tablet: 15,
                      desktop: 15,
                    ),
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile Settings'),
          content: Text('This will open the edit profile settings page.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to edit profile settings page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileView()));
              },
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement logout functionality
                // Clear user session, navigate to login page, etc.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
