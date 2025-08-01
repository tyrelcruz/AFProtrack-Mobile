import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/bottom_nav_bar.dart';
import '../utils/app_colors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const AppBarWidget(
        title: 'Profile',
        showLeading: true, // Shows back button
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 2),
            // Profile container
            Container(
              width: 400,
              height: 588,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.cardBorder, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(20),
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
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.black,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          // Name
                          Text(
                            'Juan Dela Cruz',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 3),
                          // Rank
                          Text(
                            'Sergeant (SGT)',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 3),
                          // ID
                          Text(
                            'AFP - 001234',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 14),

                      // Information Cards
                      _buildInfoCard(
                        icon: Icons.shield,
                        title: 'Special Forces Regiment',
                        detail: 'Philippine Army',
                      ),
                      SizedBox(height: 10),
                      _buildInfoCard(
                        icon: Icons.location_on,
                        title: 'Current Base',
                        detail: 'Fort Bonifacio, Taguig',
                      ),
                      SizedBox(height: 10),
                      _buildInfoCard(
                        icon: Icons.email,
                        title: 'Email',
                        detail: 'j.delacruz@afp.mil.ph',
                      ),
                      SizedBox(height: 10),
                      _buildInfoCard(
                        icon: Icons.phone,
                        title: 'Phone',
                        detail: '(+63) 912-345-6789',
                      ),
                      SizedBox(height: 10),
                      _buildInfoCard(
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
              width: 400,
              height: 133,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.cardBorder, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Outlined card'),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 3, // Assuming Profile is the 4th tab (index 3)
        onTap: (index) {
          // Handle navigation to other tabs
          // You might want to use Navigator or a callback to parent
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  detail,
                  style: TextStyle(fontSize: 13, color: AppColors.black),
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
}
