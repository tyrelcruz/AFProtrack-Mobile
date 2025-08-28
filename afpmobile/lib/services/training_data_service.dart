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

      // Fetch user's enrolled programs to determine enrollment status
      final enrolledResponse = await ApiService.getMyTrainingPrograms();

      Set<String> enrolledProgramIds = {};

      if (enrolledResponse['success']) {
        final enrolledData = enrolledResponse['data'];
        List<dynamic> enrolledPrograms = [];

        if (enrolledData is List) {
          enrolledPrograms = enrolledData;
        } else if (enrolledData is Map) {
          // Check if it has a 'programs' key (nested structure)
          if (enrolledData.containsKey('programs')) {
            enrolledPrograms = enrolledData['programs'] as List? ?? [];
          } else {
            enrolledPrograms = [enrolledData];
          }
        }

        // Extract enrolled program IDs
        for (var program in enrolledPrograms) {
          final programId = program['id'] ?? program['_id'];
          if (programId != null) {
            enrolledProgramIds.add(programId.toString());
          }
        }
      }

      if (response['success']) {
        // Support both array and wrapped object { programs: [...] }
        final dynamic data = response['data'];
        final List programsData =
            (data is List) ? data : (data?['programs'] as List? ?? []);
        for (var program in programsData) {
          final programId = program['id'] ?? program['_id'];
          final isEnrolled = enrolledProgramIds.contains(programId.toString());
          // Override the isEnrolled field with our calculated value
          program['isEnrolled'] = isEnrolled;
        }

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
    switch (filterIndex) {
      case 0: // All
        return programs;
      case 1: // Available
        return programs
            .where((program) => program.status.toLowerCase() == 'available')
            .toList();
      case 2: // In Progress
        return programs
            .where((program) => program.status.toLowerCase() == 'in progress')
            .toList();
      case 3: // Upcoming
        return programs
            .where((program) => program.status.toLowerCase() == 'upcoming')
            .toList();
      case 4: // Completed
        return programs
            .where((program) => program.status.toLowerCase() == 'completed')
            .toList();
      case 5: // Cancelled
        return programs
            .where((program) => program.status.toLowerCase() == 'cancelled')
            .toList();
      case 6: // Dropped
        return programs
            .where((program) => program.status.toLowerCase() == 'dropped')
            .toList();
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

  // Clear cache to force refresh after enrollment
  static void clearCache() {
    _cachedPrograms.clear();
    _isLoading = false;
  }
}
