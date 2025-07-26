import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../utils/app_colors.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const AppBarWidget(title: 'Schedule', showLeading: false),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    text: 'My Schedule',
                    isSelected: _selectedTabIndex == 0,
                    onTap: () => setState(() => _selectedTabIndex = 0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TabButton(
                    text: 'Ongoing',
                    isSelected: _selectedTabIndex == 1,
                    onTap: () => setState(() => _selectedTabIndex = 1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TabButton(
                    text: 'Completed',
                    isSelected: _selectedTabIndex == 2,
                    onTap: () => setState(() => _selectedTabIndex = 2),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                _ScheduleList(),
                const Center(
                  child: Text(
                    'No ongoing trainings',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const Center(
                  child: Text(
                    'No completed trainings',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                  : Border.all(color: const Color(0xFF3E503A), width: 1.5),
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

class _ScheduleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      children: [
        _ScheduleCard(
          date: 'July 26, 2025 | 8:00 AM - 2:00 PM',
          title: 'Advanced Combat Training',
          badge: 'Practical',
          badgeColor: const Color(0xFFF3F3F3),
          badgeTextColor: Color(0xFF8B8B8B),
          instructor: 'Lt. Garcia',
          location: 'Training Ground Alpha',
        ),
        _ScheduleCard(
          date: 'July 27, 2025 | 2:00 PM - 3:30 PM',
          title: 'Leadership Development Course',
          badge: 'Lecture',
          badgeColor: const Color(0xFFE6FAF7),
          badgeTextColor: Color(0xFF00BFA5),
          instructor: 'Col. Santos',
          location: 'Conference Room - A',
        ),
        _ScheduleCard(
          date: 'July 30, 2025 | 1:00 PM - 6:00 PM',
          title: 'Close Quarters Combat',
          badge: 'Practical',
          badgeColor: const Color(0xFFF3F3F3),
          badgeTextColor: Color(0xFF8B8B8B),
          instructor: 'Sgt. Sanchez',
          location: 'CQB Area - 1',
        ),
        _ScheduleCard(
          date: '',
          title: 'Strategic Decision Making',
          badge: 'Lecture',
          badgeColor: const Color(0xFFE6FAF7),
          badgeTextColor: Color(0xFF00BFA5),
          instructor: 'Col. Santos',
          location: 'Conference Room - B',
          trainingComplete: true,
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String date;
  final String title;
  final String badge;
  final Color badgeColor;
  final Color badgeTextColor;
  final String instructor;
  final String location;
  final bool trainingComplete;

  const _ScheduleCard({
    required this.date,
    required this.title,
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.instructor,
    required this.location,
    this.trainingComplete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (trainingComplete)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'Training Complete',
                style: TextStyle(
                  color: Color(0xFF3E503A),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          if (date.isNotEmpty)
            Text(
              date,
              style: TextStyle(
                color: Color(0xFF0B6000),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (date.isNotEmpty) SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.5,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, top: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Text(
            'Instructor: $instructor',
            style: TextStyle(
              color: Color(0xFF8B8B8B),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Text(
            location,
            style: TextStyle(
              color: Color(0xFF8B8B8B),
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
