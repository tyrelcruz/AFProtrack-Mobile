import '../models/training_program.dart';
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
      // Fetch all programs using the new mobile endpoint
      final response = await ApiService.getTrainingPrograms();

      if (response['success']) {
        // Support both array and wrapped object { programs: [...] }
        final dynamic data = response['data'];
        final List programsData =
            (data is List) ? data : (data?['programs'] as List? ?? []);
        print('=== DEBUG: Raw API response programs ===');
        for (var program in programsData) {
          print(
            'Raw program: ${program['programName']}, CalculatedStatus: "${program['calculatedStatus']}"',
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
      case 0: // All
        print('All programs returned: ${programs.length}');
        return programs;
      case 1: // Available
        final availablePrograms =
            programs
                .where((program) => program.status.toLowerCase() == 'available')
                .toList();
        print('Available programs found: ${availablePrograms.length}');
        return availablePrograms;
      case 2: // In Progress
        final inProgressPrograms =
            programs
                .where(
                  (program) => program.status.toLowerCase() == 'in progress',
                )
                .toList();
        print('In-progress programs found: ${inProgressPrograms.length}');
        return inProgressPrograms;
      case 3: // Upcoming
        final upcomingPrograms =
            programs
                .where((program) => program.status.toLowerCase() == 'upcoming')
                .toList();
        print('Upcoming programs found: ${upcomingPrograms.length}');
        return upcomingPrograms;
      case 4: // Completed
        final completedPrograms =
            programs
                .where((program) => program.status.toLowerCase() == 'completed')
                .toList();
        print('Completed programs found: ${completedPrograms.length}');
        return completedPrograms;
      case 5: // Cancelled
        final cancelledPrograms =
            programs
                .where((program) => program.status.toLowerCase() == 'cancelled')
                .toList();
        print('Cancelled programs found: ${cancelledPrograms.length}');
        return cancelledPrograms;
      case 6: // Dropped
        final droppedPrograms =
            programs
                .where((program) => program.status.toLowerCase() == 'dropped')
                .toList();
        print('Dropped programs found: ${droppedPrograms.length}');
        return droppedPrograms;
      default:
        return programs;
    }
  }

  static String getEmptyStateMessage(int filterIndex) {
    switch (filterIndex) {
      case 0:
        return 'No programs found';
      case 1:
        return 'No available programs';
      case 2:
        return 'No programs in progress';
      case 3:
        return 'No upcoming programs';
      case 4:
        return 'No completed programs';
      case 5:
        return 'No cancelled programs';
      case 6:
        return 'No dropped programs';
      default:
        return 'No programs found';
    }
  }
}
