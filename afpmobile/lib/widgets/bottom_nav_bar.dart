import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:afpmobile/widgets/bottom_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color indicatorColor = const Color(0xFF3E503A);
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: AppColors.armyPrimary,
      unselectedItemColor: Colors.black54,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.appBackground,
      elevation: 8,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 42,
                decoration: BoxDecoration(
                  color:
                      currentIndex == 0 ? indicatorColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2),
              Icon(Icons.dashboard),
            ],
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 42,
                decoration: BoxDecoration(
                  color:
                      currentIndex == 1 ? indicatorColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2),
              Icon(Icons.calendar_today),
            ],
          ),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 42,
                decoration: BoxDecoration(
                  color:
                      currentIndex == 2 ? indicatorColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2),
              Icon(Icons.school),
            ],
          ),
          label: 'Training',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 42,
                decoration: BoxDecoration(
                  color:
                      currentIndex == 3 ? indicatorColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2),
              Icon(Icons.verified),
            ],
          ),
          label: 'Certificate',
        ),
      ],
    );
  }
}
