import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: const AppBarWidget(
        title: 'Schedule',
        showLeading: false, // No back button since it's a main tab
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Schedule View',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your training schedule will appear here',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
