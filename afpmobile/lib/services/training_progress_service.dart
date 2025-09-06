import '../models/schedule_program.dart';
import 'schedule_data_service.dart';
import 'api_service.dart';

class TrainingProgressService {
  /// Calculate training progress based on schedule data
  static Future<Map<String, dynamic>> getTrainingProgress() async {
    try {
      final programs = await ScheduleDataService.getMyTrainingPrograms();

      int completed = 0;
      int ongoing = 0;
      int scheduled = 0;
      int certificates = 0;
      double overallProgress = 0.0;
      double combatReadiness = 0.0;

      // Count programs by status
      for (final program in programs) {
        final status = program.calculatedStatus.toLowerCase();

        if (status == 'completed') {
          completed++;
        } else if (_isProgramCurrentlyActive(program)) {
          ongoing++;
        } else if (status == 'upcoming' || status == 'scheduled') {
          scheduled++;
        }
      }

      // Calculate overall training progress based on completed vs total
      final totalPrograms = programs.length;
      if (totalPrograms > 0) {
        overallProgress = (completed / totalPrograms) * 100;
      }

      // Calculate combat readiness based on ongoing programs progress
      if (ongoing > 0) {
        double totalOngoingProgress = 0.0;
        int ongoingCount = 0;

        for (final program in programs) {
          if (_isProgramCurrentlyActive(program)) {
            final progress = _calculateProgramProgress(program);
            totalOngoingProgress += progress;
            ongoingCount++;
          }
        }

        if (ongoingCount > 0) {
          combatReadiness = totalOngoingProgress / ongoingCount;
        }
      }

      // Estimate certificates based on completed programs (assuming 80% completion rate)
      certificates = (completed * 0.8).round();

      return {
        'completed': completed,
        'ongoing': ongoing,
        'scheduled': scheduled,
        'certificates': certificates,
        'overallProgress': overallProgress.round(),
        'combatReadiness': combatReadiness.round(),
      };
    } catch (e) {
      print('Error calculating training progress: $e');
      return {
        'completed': 0,
        'ongoing': 0,
        'scheduled': 0,
        'certificates': 0,
        'overallProgress': 0,
        'combatReadiness': 0,
      };
    }
  }

  /// Calculate progress for a specific program based on days passed
  static double _calculateProgramProgress(ScheduleProgram program) {
    try {
      final startDate = DateTime.parse(program.startDate);
      final endDate = DateTime.parse(program.endDate);
      final now = DateTime.now();

      // If program hasn't started yet
      if (now.isBefore(startDate)) {
        return 0.0;
      }

      // If program is completed
      if (now.isAfter(endDate)) {
        return 100.0;
      }

      // Calculate progress based on days passed
      final totalDuration = endDate.difference(startDate).inDays;
      final daysPassed = now.difference(startDate).inDays;

      if (totalDuration <= 0) {
        return 0.0;
      }

      final progress = (daysPassed / totalDuration) * 100;
      return progress.clamp(0.0, 100.0);
    } catch (e) {
      print('Error calculating program progress: $e');
      return 0.0;
    }
  }

  /// Get current enrolled programs with their progress
  static Future<List<Map<String, dynamic>>> getCurrentTrainingPrograms() async {
    try {
      // Use the my-programs endpoint to get all enrolled programs
      final response = await ApiService.getMyTrainingPrograms();
      final enrolledPrograms = <Map<String, dynamic>>[];

      if (!response['success']) {
        print('❌ Failed to fetch enrolled programs: ${response['message']}');
        return [];
      }

      final programsData = response['data'];
      List<dynamic> programs = [];

      // Handle different response structures
      if (programsData is List) {
        programs = programsData;
      } else if (programsData is Map && programsData.containsKey('programs')) {
        programs = programsData['programs'] as List? ?? [];
      }

      print(
        '📊 TrainingProgressService: Found ${programs.length} enrolled programs',
      );

      for (final programData in programs) {
        final program = ScheduleProgram.fromJson(programData);
        print(
          '📊 Program: ${program.programName} - Status: ${program.calculatedStatus} - Start: ${program.startDate} - End: ${program.endDate}',
        );

        // Show all enrolled programs regardless of status
        final progress = _calculateProgramProgress(program);
        print(
          '📊 Adding enrolled program: ${program.programName} with progress: $progress%',
        );

        enrolledPrograms.add({
          'id': program.id,
          'name': program.programName,
          'instructor': program.instructor,
          'venue': program.venue,
          'startDate': program.startDate,
          'endDate': program.endDate,
          'duration': program.duration,
          'status': program.calculatedStatus,
          'progress': progress,
          'grade': _getEstimatedGrade(progress),
          'nextSession': _getNextSession(program),
        });
      }

      print(
        '📊 TrainingProgressService: Returning ${enrolledPrograms.length} enrolled programs',
      );
      return enrolledPrograms;
    } catch (e) {
      print('Error getting current training programs: $e');
      return [];
    }
  }

  /// Check if a program is currently active
  static bool _isProgramCurrentlyActive(ScheduleProgram program) {
    try {
      final now = DateTime.now();
      final startDate = DateTime.parse(program.startDate);
      final endDate = DateTime.parse(program.endDate);

      // Check if program is between start and end dates
      final isWithinDateRange = now.isAfter(startDate) && now.isBefore(endDate);

      // Also check for specific status values that indicate ongoing programs
      final status = program.calculatedStatus.toLowerCase();
      final isOngoingStatus =
          status == 'in progress' ||
          status == 'ongoing' ||
          status == 'active' ||
          status == 'current';

      final isActive = isWithinDateRange || isOngoingStatus;

      print('📊 Checking program ${program.programName}:');
      print('   - Status: $status');
      print('   - Start: $startDate, End: $endDate, Now: $now');
      print('   - Within date range: $isWithinDateRange');
      print('   - Ongoing status: $isOngoingStatus');
      print('   - Is active: $isActive');

      return isActive;
    } catch (e) {
      print('Error checking if program is active: $e');
      return false;
    }
  }

  /// Estimate grade based on progress
  static String _getEstimatedGrade(double progress) {
    if (progress >= 90) return 'A+';
    if (progress >= 80) return 'A';
    if (progress >= 70) return 'B+';
    if (progress >= 60) return 'B';
    if (progress >= 50) return 'C+';
    if (progress >= 40) return 'C';
    return 'D';
  }

  /// Get next session information
  static String? _getNextSession(ScheduleProgram program) {
    try {
      final now = DateTime.now();
      final startDate = DateTime.parse(program.startDate);
      final endDate = DateTime.parse(program.endDate);

      // If program hasn't started, next session is the start date
      if (now.isBefore(startDate)) {
        return 'Starts ${_formatDate(startDate)}';
      }

      // If program is ongoing, next session is tomorrow (simplified)
      if (now.isAfter(startDate) && now.isBefore(endDate)) {
        final tomorrow = now.add(const Duration(days: 1));
        return 'Next: ${_formatDate(tomorrow)}';
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Format date for display
  static String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
