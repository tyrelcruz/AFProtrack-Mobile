import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../views/notification_view.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
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
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  bool _isNavigating = false;

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
