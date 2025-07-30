import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../views/notification_view.dart';

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
        decoration: BoxDecoration(color: AppColors.appBackground),
        child: AppBar(
          backgroundColor: AppColors.appBackground,
          elevation: 0,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
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
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NotificationView(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.account_circle,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
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
