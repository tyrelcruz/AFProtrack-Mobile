import 'package:flutter/material.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/training_stats_widget.dart';
import '../widgets/career_progression_card.dart';
import '../widgets/app_bar_widget.dart';
import '../models/home_training_program.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';
import '../widgets/responsive_test_widget.dart';
import '../services/token_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await TokenService.getUserData();
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper methods to extract user data with fallbacks
  String _getUserName() {
    if (_userData != null) {
      return '${_userData!['firstName'] ?? ''} ${_userData!['lastName'] ?? ''}'
          .trim();
    }
    return 'Juan Dela Cruz'; // Fallback
  }

  String _getUserRank() {
    if (_userData != null) {
      return _userData!['rank'] ?? 'Sergeant (SGT)';
    }
    return 'Sergeant (SGT)'; // Fallback
  }

  String _getUserUnit() {
    if (_userData != null) {
      return _userData!['unit'] ?? 'Special Forces Regiment';
    }
    return 'Special Forces Regiment'; // Fallback
  }

  String _getUserServiceId() {
    if (_userData != null) {
      return _userData!['serviceId'] ?? 'AFP - 001234';
    }
    return 'AFP - 001234'; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final programs = [
      HomeTrainingProgram(
        title: 'Advanced Combat Training',
        instructor: 'Lt. Garcia',
        progress: 0.65,
        grade: 'A-',
        nextSession: DateTime(2025, 7, 26, 8, 0),
        status: 'Ongoing',
      ),
      HomeTrainingProgram(
        title: 'Leadership Development Course',
        instructor: 'Col. Santos',
        progress: 0.48,
        grade: 'B+',
        nextSession: DateTime(2025, 8, 2, 10, 0),
        status: 'Ongoing',
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isLoading
                ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
                : UserProfileCard(
                  name: _getUserName(),
                  rank: _getUserRank(),
                  unit: _getUserUnit(),
                  serviceId: _getUserServiceId(),
                  trainingProgress: 80,
                  readinessLevel: 97,
                  cardColor: Colors.white,
                ),
            SizedBox(height: 12),
            TrainingStatsWidget(),
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
                      (HomeTrainingProgram p) => Padding(
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
            // Responsive test button (for development)
            if (ResponsiveUtils.isTablet(context) ||
                ResponsiveUtils.isDesktop(context))
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ResponsiveTestWidget(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.getResponsivePadding(context),
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Test Responsive Design',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        mobile: 14.0,
                        tablet: 16.0,
                        desktop: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
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
