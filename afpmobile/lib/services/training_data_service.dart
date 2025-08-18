import '../models/training_program.dart';
import '../utils/app_colors.dart';

class TrainingDataService {
  static List<TrainingProgram> getAllTrainingPrograms() {
    return [
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
        batch: 'LDC-2025-A',
        instructor: 'Lt. Garcia',
        venue: 'Conference Room - A',
        participants: '15/25',
        enrollmentDate: 'July 26, 2025',
        isEnrollmentActive: true,
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
        batch: 'TFE-2025-B',
        instructor: 'Col. Santos',
        venue: 'Training Ground Alpha',
        participants: '8/20',
        enrollmentDate: 'July 27, 2025',
        isEnrollmentActive: true,
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
        batch: 'CQC-2025-C',
        instructor: 'Sgt. Sanchez',
        venue: 'CQB Area - 1',
        participants: '12/15',
        enrollmentDate: 'June 15, 2025',
        isEnrollmentActive: false,
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
        batch: 'LDC-2025-A',
        instructor: 'Sgt. Ramirez',
        venue: 'Laboratory - A',
        participants: '0/40',
        enrollmentDate: 'July 30, 2025',
        isEnrollmentActive: false,
      ),
    ];
  }

  static List<TrainingProgram> getFilteredPrograms(
    List<TrainingProgram> programs,
    int filterIndex,
  ) {
    switch (filterIndex) {
      case 0: // All Programs
        return programs;
      case 1: // Available
        return programs
            .where((program) => program.status == 'Available')
            .toList();
      case 2: // In Progress
        return programs
            .where((program) => program.status == 'In Progress')
            .toList();
      default:
        return programs;
    }
  }

  static String getEmptyStateMessage(int filterIndex) {
    switch (filterIndex) {
      case 1:
        return 'No available programs';
      case 2:
        return 'No programs in progress';
      default:
        return 'No programs found';
    }
  }
}
