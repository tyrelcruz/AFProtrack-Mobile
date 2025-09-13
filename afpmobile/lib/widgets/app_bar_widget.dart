import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../views/notification_view.dart';
import '../views/profile_view.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading;
  final Widget? leading;
  final VoidCallback? onProfileReturn;

  const AppBarWidget({
    Key? key,
    this.title = 'AFProTrack',
    this.actions,
    this.showLeading = false,
    this.leading,
    this.onProfileReturn,
  }) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.appBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0, 1),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          automaticallyImplyLeading: widget.showLeading,
          leading: widget.leading,
          actions:
              widget.actions ??
              [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed:
                      _isNavigating
                          ? null
                          : () async {
                            if (_isNavigating) return;

                            // Check if we're already on the notification screen
                            final currentRoute = ModalRoute.of(context);
                            if (currentRoute?.settings.name ==
                                '/notifications') {
                              return; // Already on notification screen, do nothing
                            }

                            setState(() {
                              _isNavigating = true;
                            });

                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                settings: const RouteSettings(
                                  name: '/notifications',
                                ),
                                builder: (context) => const NotificationView(),
                              ),
                            );

                            setState(() {
                              _isNavigating = false;
                            });
                          },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.account_circle,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () async {
                    // Check if we're already on the profile screen
                    final currentRoute = ModalRoute.of(context);
                    if (currentRoute?.settings.name == '/profile') {
                      return; // Already on profile screen, do nothing
                    }

                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: '/profile'),
                        builder: (context) => const ProfileView(),
                      ),
                    );

                    // Call the callback when returning from profile view
                    if (widget.onProfileReturn != null) {
                      widget.onProfileReturn!();
                    }
                  },
                ),
              ],
        ),
      ),
    );
  }
}
