import '../models/schedule_program.dart';
import 'api_service.dart';

class ScheduleDataService {
  static List<ScheduleProgram> _cachedPrograms = [];
  static bool _isLoading = false;

  static Future<List<ScheduleProgram>> getMyTrainingPrograms() async {
    // Return cached data if available and not loading
    if (_cachedPrograms.isNotEmpty && !_isLoading) {
      return _cachedPrograms;
    }

    _isLoading = true;

    try {
      final response = await ApiService.getMyTrainingPrograms();

      if (response['success']) {
        final programsData = response['data']['programs'] as List;

        _cachedPrograms =
            programsData
                .map((program) => ScheduleProgram.fromJson(program))
                .toList();
        return _cachedPrograms;
      } else {
        print('Failed to fetch schedule programs: ${response['message']}');
        return [];
      }
    } catch (e) {
      print('Error fetching schedule programs: $e');
      return [];
    } finally {
      _isLoading = false;
    }
  }

  static List<ScheduleProgram> getFilteredPrograms(
    List<ScheduleProgram> programs,
    int filterIndex,
  ) {
    switch (filterIndex) {
      case 0: // My Schedule (All)
        return programs;
      case 1: // Ongoing
        return programs
            .where(
              (program) =>
                  program.calculatedStatus.toLowerCase() == 'in progress',
            )
            .toList();
      case 2: // Completed
        return programs
            .where(
              (program) =>
                  program.calculatedStatus.toLowerCase() == 'completed',
            )
            .toList();
      default:
        return programs;
    }
  }

  static String getEmptyStateMessage(int filterIndex) {
    switch (filterIndex) {
      case 0:
        return 'No scheduled programs';
      case 1:
        return 'No ongoing programs';
      case 2:
        return 'No completed programs';
      default:
        return 'No programs found';
    }
  }
}
