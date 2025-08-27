import '../models/training_program.dart';
import '../utils/app_colors.dart';
import 'api_service.dart';

class TrainingDataService {
  static List<TrainingProgram> _cachedPrograms = [];
  static bool _isLoading = false;

  static Future<List<TrainingProgram>> getAllTrainingPrograms() async {
    // Return cached data if available and not loading
    if (_cachedPrograms.isNotEmpty && !_isLoading) {
      return _cachedPrograms;
    }

    _isLoading = true;

    try {
      // Fetch only available programs for the mobile list per requirement
      final response = await ApiService.getAvailableTrainingPrograms();

      if (response['success']) {
        final programsData = response['data']['programs'] as List;
        print('=== DEBUG: Raw API response programs ===');
        for (var program in programsData) {
          print(
            'Raw program: ${program['programName']}, Status: "${program['status']}"',
          );
        }
        print('=== END DEBUG ===');

        _cachedPrograms =
            programsData
                .map((program) => TrainingProgram.fromJson(program))
                .toList();
        return _cachedPrograms;
      } else {
        print('Failed to fetch training programs: ${response['message']}');
        return [];
      }
    } catch (e) {
      print('Error fetching training programs: $e');
      return [];
    } finally {
      _isLoading = false;
    }
  }

  static List<TrainingProgram> getFilteredPrograms(
    List<TrainingProgram> programs,
    int filterIndex,
  ) {
    // Debug: Print all programs and their statuses
    print('=== DEBUG: All programs and their statuses ===');
    for (var program in programs) {
      print('Program: ${program.programName}, Status: "${program.status}"');
    }
    print('=== END DEBUG ===');

    switch (filterIndex) {
      case 0: // Available
        final availablePrograms =
            programs
                .where((program) => program.status.toLowerCase() == 'available')
                .toList();
        print('Available programs found: ${availablePrograms.length}');
        return availablePrograms;
      case 1: // In Progress
        final ongoingPrograms =
            programs
                .where((program) => program.status.toLowerCase() == 'ongoing')
                .toList();
        print('Ongoing programs found: ${ongoingPrograms.length}');
        return ongoingPrograms;
      case 2: // Upcoming
        final draftPrograms =
            programs
                .where((program) => program.status.toLowerCase() == 'draft')
                .toList();
        print('Draft programs found: ${draftPrograms.length}');
        return draftPrograms;
      case 3: // Completed
        final completedPrograms =
            programs
                .where((program) => program.status.toLowerCase() == 'completed')
                .toList();
        print('Completed programs found: ${completedPrograms.length}');
        return completedPrograms;
      default:
        return programs;
    }
  }

  static String getEmptyStateMessage(int filterIndex) {
    switch (filterIndex) {
      case 0:
        return 'No available programs';
      case 1:
        return 'No programs in progress';
      case 2:
        return 'No upcoming programs';
      case 3:
        return 'No completed programs';
      default:
        return 'No programs found';
    }
  }
}
