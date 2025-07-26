import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading;
  final Widget? leading;

  const AppBarWidget({
    Key? key,
    this.title = 'AFProTrack',
    this.actions,
    this.showLeading = false,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: AppColors.armyPrimary,
          elevation: 0,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          automaticallyImplyLeading: showLeading,
          leading: leading,
          actions:
              actions ??
              [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // TODO: Implement notifications
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.account_circle, color: Colors.white),
                  onPressed: () {
                    // TODO: Implement profile navigation
                  },
                ),
              ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
