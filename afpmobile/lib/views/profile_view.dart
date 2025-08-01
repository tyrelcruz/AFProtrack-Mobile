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

      bottomNavigationBar: BottomNavBar(
        currentIndex: 3, // Assuming Profile is the 4th tab (index 3)
        onTap: (index) {
          // Handle navigation to other tabs
          // You might want to use Navigator or a callback to parent
        },
      ),
    );
  }
}
