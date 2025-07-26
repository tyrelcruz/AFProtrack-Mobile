import 'package:flutter/material.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/stats_grid.dart';
import '../widgets/training_program_card.dart';
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
                    SizedBox(height: 3),
                    ...programs.map(
                      (p) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: TrainingProgramCard(
                          program: p,
                          cardColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            SizedBox(height: 20), // Reduced spacing since no bottom nav bar
          ],
        ),
      ),
    );
  }
}
