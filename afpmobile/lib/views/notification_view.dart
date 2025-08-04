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
      backgroundColor: Colors.grey[50],
      appBar: const AppBarWidget(title: 'Notifications', showLeading: true),
      body: Column(
        children: [
          // Tab buttons container - made more compact
          Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    text: 'All (${_allNotifications.length})',
                    isSelected: _selectedTabIndex == 0,
                    onTap: () => setState(() => _selectedTabIndex = 0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TabButton(
                    text:
                        'Unread (${_allNotifications.where((n) => !n.isRead).length})',
                    isSelected: _selectedTabIndex == 1,
                    onTap: () => setState(() => _selectedTabIndex = 1),
                  ),
                ),
                const SizedBox(width: 8),
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
          // Notification list - simplified container
          Expanded(
            child:
                _filteredNotifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        return _NotificationCard(
                          notification: _filteredNotifications[index],
                          onTap:
                              () => _markAsRead(_filteredNotifications[index]),
                        );
                      },
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

    switch (_selectedTabIndex) {
      case 1: // Unread
        message = 'No Unread Notifications';
        subtitle = 'You\'re all caught up!';
        icon = Icons.mark_email_unread_outlined;
        break;
      case 2: // Read
        message = 'No Read Notifications';
        subtitle = 'Notifications you\'ve read will appear here';
        icon = Icons.mark_email_read_outlined;
        break;
      default: // All
        message = 'No Notifications Yet';
        subtitle = 'You\'ll see important updates here';
        icon = Icons.notifications_none;
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
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
                  : Border.all(
                    color: const Color(0xFFC4C4C4).withOpacity(0.4),
                    width: 1.5,
                  ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : Colors.blue[25],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification type icon - simplified
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getNotificationTypeColor(
                    notification.type,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getNotificationTypeIcon(notification.type),
                  color: _getNotificationTypeColor(
                    notification.type,
                  ).withOpacity(0.7),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
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
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.blue[600],
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.time,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
