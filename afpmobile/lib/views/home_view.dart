import 'package:flutter/material.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/stats_grid.dart';
import '../widgets/career_progression_card.dart';
import '../widgets/app_bar_widget.dart';
import '../models/training_program.dart';
import '../utils/app_colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final stats = [
      StatItem(
        icon: Icons.check_circle,
        label: 'Completed',
        value: 10,
        color: Colors.green,
      ),
      StatItem(
        icon: Icons.autorenew,
        label: 'Ongoing',
        value: 2,
        color: Colors.blue,
      ),
      StatItem(
        icon: Icons.event,
        label: 'Scheduled',
        value: 3,
        color: Colors.orange,
      ),
      StatItem(
        icon: Icons.verified,
        label: 'Certificates',
        value: 7,
        color: Colors.purple,
      ),
    ];
    final programs = [
      TrainingProgram(
        title: 'Advanced Combat Training',
        instructor: 'Lt. Garcia',
        progress: 0.65,
        grade: 'A-',
        nextSession: DateTime(2025, 7, 26, 8, 0),
        status: 'Ongoing',
      ),
      TrainingProgram(
        title: 'Leadership Development Course',
        instructor: 'Col. Santos',
        progress: 0.48,
        grade: 'B+',
        nextSession: DateTime(2025, 8, 2, 10, 0),
        status: 'Ongoing',
      ),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileCard(
              name: 'Juan Dela Cruz',
              rank: 'Sergeant (SGT)',
              unit: 'Special Forces Regiment',
              serviceId: 'AFP - 001234',
              trainingProgress: 80,
              readinessLevel: 97,
              cardColor: Colors.white,
            ),
            StatsGrid(items: stats),
            CareerProgressionCard(
              currentRank: 'Sergeant (SGT)',
              nextRank: 'Staff Sergeant (SSG)',
              timeInRank: '2 years, 3 months',
              progress: 0.7,
              requirements: [
                PromotionRequirement(
                  label: 'Completed Leadership Course',
                  passed: true,
                ),
                PromotionRequirement(
                  label: 'Minimum 2 years in rank',
                  passed: true,
                ),
                PromotionRequirement(
                  label: 'Passed Physical Fitness Test',
                  passed: false,
                ),
                PromotionRequirement(label: 'Staff Endorsement', passed: false),
              ],
            ),
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Training Programs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    ...programs.map(
                      (p) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.school,
                                    color: Colors.blue[700],
                                    size: 16,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Instructor: ${p.instructor}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      p.status,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _getStatusColor(
                                        p.status,
                                      ).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    p.status,
                                    style: TextStyle(
                                      color: _getStatusColor(p.status),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Progress',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black87,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${(p.progress * 100).toInt()}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3),
                            LinearProgressIndicator(
                              value: p.progress,
                              minHeight: 5,
                              backgroundColor: Colors.grey[200],
                              color: Colors.green[700],
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  'Grade: ${p.grade}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            if (p.nextSession != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Next Session: ${_formatDate(p.nextSession!)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            if (p != programs.last)
                              Divider(height: 16, color: Colors.grey[300]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20), // Reduced spacing since no bottom nav bar
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ongoing':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Scheduled':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
