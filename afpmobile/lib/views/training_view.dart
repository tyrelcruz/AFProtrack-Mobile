import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../utils/app_colors.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({Key? key}) : super(key: key);

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingView> {
  int _selectedFilterIndex = 0;

  final List<TrainingProgram> _trainingPrograms = [
    TrainingProgram(
      title: 'Leadership Development Course',
      duration: '1 week',
      status: 'Available',
      statusColor: AppColors.trainingAvailableBg,
      statusTextColor: AppColors.trainingAvailableText,
      buttonText: 'View Training Details',
      buttonColor: AppColors.trainingButtonPrimary,
      buttonTextColor: AppColors.white,
      isDisabled: false,
    ),
    TrainingProgram(
      title: 'Tactical Field Exercise',
      duration: '12 weeks',
      status: 'Available',
      statusColor: AppColors.trainingAvailableBg,
      statusTextColor: AppColors.trainingAvailableText,
      buttonText: 'View Training Details',
      buttonColor: AppColors.trainingButtonPrimary,
      buttonTextColor: AppColors.white,
      isDisabled: false,
    ),
    TrainingProgram(
      title: 'Close Quarters Combat',
      duration: '15 weeks',
      status: 'In Progress',
      statusColor: AppColors.trainingInProgressBg,
      statusTextColor: AppColors.trainingInProgressText,
      buttonText: 'Currently Enrolled',
      buttonColor: AppColors.trainingButtonDisabled,
      buttonTextColor: AppColors.trainingButtonDisabledText,
      isDisabled: true,
    ),
    TrainingProgram(
      title: 'Cybersecurity Operations',
      duration: '12 weeks',
      status: 'Upcoming',
      statusColor: AppColors.trainingUpcomingBg,
      statusTextColor: AppColors.trainingUpcomingText,
      buttonText: 'View Training Details',
      buttonColor: AppColors.trainingButtonPrimary,
      buttonTextColor: AppColors.white,
      isDisabled: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.trainingBackground,
      appBar: const AppBarWidget(title: 'Training', showLeading: false),
      body: Column(
        children: [
          // Filter Bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _FilterButton(
                    text: 'All Programs',
                    isSelected: _selectedFilterIndex == 0,
                    onTap: () => setState(() => _selectedFilterIndex = 0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FilterButton(
                    text: 'Available',
                    isSelected: _selectedFilterIndex == 1,
                    onTap: () => setState(() => _selectedFilterIndex = 1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FilterButton(
                    text: 'In Progress',
                    isSelected: _selectedFilterIndex == 2,
                    onTap: () => setState(() => _selectedFilterIndex = 2),
                  ),
                ),
              ],
            ),
          ),
          // Training Programs List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _trainingPrograms.length,
              itemBuilder: (context, index) {
                return _TrainingProgramCard(program: _trainingPrograms[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
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
          color: isSelected ? AppColors.filterBorder : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              isSelected
                  ? null
                  : Border.all(color: AppColors.filterBorder, width: 1.5),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.filterBorder,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _TrainingProgramCard extends StatelessWidget {
  final TrainingProgram program;

  const _TrainingProgramCard({required this.program});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Duration: ${program.duration}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: program.statusColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  program.status,
                  style: TextStyle(
                    color: program.statusTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed:
                  program.isDisabled
                      ? null
                      : () {
                        // TODO: Implement training details navigation
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: program.buttonColor,
                foregroundColor: program.buttonTextColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: program.buttonColor,
                disabledForegroundColor: program.buttonTextColor,
              ),
              child: Text(
                program.buttonText,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrainingProgram {
  final String title;
  final String duration;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;
  final bool isDisabled;

  TrainingProgram({
    required this.title,
    required this.duration,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.isDisabled,
  });
}
