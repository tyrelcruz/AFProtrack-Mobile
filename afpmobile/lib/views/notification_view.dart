import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../utils/app_colors.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  int _selectedTabIndex = 0;

  final List<NotificationItem> _allNotifications = [
    NotificationItem(
      title: 'Training Reminder',
      message: 'Leadership Development Course starts in 30 minutes',
      time: '2 hours ago',
      type: NotificationType.training,
      isRead: false,
    ),
    NotificationItem(
      title: 'Certificate Earned',
      message:
          'Congratulations! You have earned the Basic Leadership Certificate',
      time: '1 day ago',
      type: NotificationType.certificate,
      isRead: false,
    ),
    NotificationItem(
      title: 'Schedule Update',
      message:
          'Your training session has been rescheduled to tomorrow at 10:00 AM',
      time: '2 days ago',
      type: NotificationType.schedule,
      isRead: true,
    ),
    NotificationItem(
      title: 'Promotion Progress',
      message: 'You are 75% complete towards your next promotion requirements',
      time: '3 days ago',
      type: NotificationType.progress,
      isRead: true,
    ),
    NotificationItem(
      title: 'New Training Available',
      message: 'Advanced Combat Training is now available for enrollment',
      time: '1 week ago',
      type: NotificationType.training,
      isRead: true,
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    switch (_selectedTabIndex) {
      case 0: // All
        return _allNotifications;
      case 1: // Unread
        return _allNotifications.where((n) => !n.isRead).toList();
      case 2: // Read
        return _allNotifications.where((n) => n.isRead).toList();
      default:
        return _allNotifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const AppBarWidget(title: 'Notifications', showLeading: true),
      body: Column(
        children: [
          // Tab buttons container
          Container(
            color: AppColors.appBackground,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    text: 'All (${_allNotifications.length})',
                    isSelected: _selectedTabIndex == 0,
                    onTap: () => setState(() => _selectedTabIndex = 0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TabButton(
                    text:
                        'Unread (${_allNotifications.where((n) => !n.isRead).length})',
                    isSelected: _selectedTabIndex == 1,
                    onTap: () => setState(() => _selectedTabIndex = 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TabButton(
                    text:
                        'Read (${_allNotifications.where((n) => n.isRead).length})',
                    isSelected: _selectedTabIndex == 2,
                    onTap: () => setState(() => _selectedTabIndex = 2),
                  ),
                ),
              ],
            ),
          ),
          // Notification list
          Expanded(
            child:
                _filteredNotifications.isEmpty
                    ? _buildEmptyState()
                    : Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredNotifications.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              _NotificationCard(
                                notification: _filteredNotifications[index],
                                onTap:
                                    () => _markAsRead(
                                      _filteredNotifications[index],
                                    ),
                              ),
                              if (index < _filteredNotifications.length - 1)
                                Divider(
                                  height: 1,
                                  color: Colors.grey[200],
                                  indent: 60,
                                  endIndent: 0,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    String subtitle;
    IconData icon;
    Color iconColor;

    switch (_selectedTabIndex) {
      case 1: // Unread
        message = 'No Unread Notifications';
        subtitle = 'You\'re all caught up!';
        icon = Icons.mark_email_unread_outlined;
        iconColor = Colors.green;
        break;
      case 2: // Read
        message = 'No Read Notifications';
        subtitle = 'Notifications you\'ve read will appear here';
        icon = Icons.mark_email_read_outlined;
        iconColor = Colors.blue;
        break;
      default: // All
        message = 'No Notifications Yet';
        subtitle = 'You\'ll see important updates here';
        icon = Icons.notifications_none;
        iconColor = Colors.grey;
        break;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: iconColor),
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _markAsRead(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3E503A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              isSelected
                  ? null
                  : Border.all(color: const Color(0xFF3E503A), width: 1),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF3E503A),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: notification.isRead ? Colors.white : Colors.blue[50],
          border:
              notification.isRead
                  ? Border.all(color: Colors.grey[200]!, width: 1)
                  : Border.all(color: Colors.blue[200]!, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification type icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getNotificationTypeColor(
                  notification.type,
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _getNotificationTypeColor(
                    notification.type,
                  ).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                _getNotificationTypeIcon(notification.type),
                color: _getNotificationTypeColor(notification.type),
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight:
                                notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                            fontSize: 16,
                            color:
                                notification.isRead
                                    ? Colors.grey[700]
                                    : Colors.black87,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          notification.isRead
                              ? Colors.grey[600]
                              : Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        notification.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (!notification.isRead)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue[200]!,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'New',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNotificationTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.training:
        return Colors.blue;
      case NotificationType.certificate:
        return Colors.green;
      case NotificationType.schedule:
        return Colors.orange;
      case NotificationType.progress:
        return Colors.purple;
    }
  }

  IconData _getNotificationTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.training:
        return Icons.school;
      case NotificationType.certificate:
        return Icons.verified;
      case NotificationType.schedule:
        return Icons.calendar_today;
      case NotificationType.progress:
        return Icons.trending_up;
    }
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });
}

enum NotificationType { training, certificate, schedule, progress }
