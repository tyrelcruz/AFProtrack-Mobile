import 'package:flutter/material.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/training_stats_widget.dart';
import '../widgets/career_progression_card.dart';
import '../widgets/skeleton_loading.dart';
import '../widgets/app_bar_widget.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';
import '../widgets/responsive_test_widget.dart';
import '../services/token_service.dart';
import '../services/api_service.dart';
import '../services/training_progress_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _profilePhotoUrl;
  bool _isLoadingProfilePhoto = false;
  int _trainingProgress = 10;
  int _combatReadiness = 40;
  List<Map<String, dynamic>> _currentTrainingPrograms = [];
  bool _isLoadingPrograms = true;
  bool _isLoadingProgress = true;
  bool _isLoadingStats = true;
  bool _isLoadingCareer = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchProfilePhoto();
    _loadTrainingProgress();
    _loadCurrentTrainingPrograms();
    _loadStatsAndCareer();
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

  Future<void> _loadTrainingProgress() async {
    try {
      final progressData = await TrainingProgressService.getTrainingProgress();
      setState(() {
        _trainingProgress = progressData['overallProgress'] ?? 10;
        _combatReadiness = progressData['combatReadiness'] ?? 40;
        _isLoadingProgress = false;
      });
    } catch (e) {
      print('Error loading training progress: $e');
      setState(() {
        _isLoadingProgress = false;
      });
      // Keep default values if loading fails
    }
  }

  /// Refresh training progress data (can be called when returning from schedule view)
  Future<void> refreshTrainingProgress() async {
    await _loadTrainingProgress();
    await _loadCurrentTrainingPrograms();
  }

  /// Simulate loading for stats and career components
  Future<void> _loadStatsAndCareer() async {
    // Simulate loading time for stats and career data
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _isLoadingStats = false;
      _isLoadingCareer = false;
    });
  }

  Future<void> _loadCurrentTrainingPrograms() async {
    try {
      setState(() {
        _isLoadingPrograms = true;
      });

      final programs =
          await TrainingProgressService.getCurrentTrainingPrograms();
      setState(() {
        _currentTrainingPrograms = programs;
        _isLoadingPrograms = false;
      });
    } catch (e) {
      print('Error loading current training programs: $e');
      setState(() {
        _currentTrainingPrograms = [];
        _isLoadingPrograms = false;
      });
    }
  }

  Future<void> _fetchProfilePhoto() async {
    setState(() {
      _isLoadingProfilePhoto = true;
    });

    try {
      print('🏠 Home: Fetching user profile photo...');
      final result = await ApiService.getUserProfilePhoto();

      print('🏠 Home: Profile photo result: $result');

      if (result['success']) {
        if (result['data'] != null) {
          final photoData = result['data'];
          print('🏠 Home: Photo data received: $photoData');

          if (photoData['cloudinaryUrl'] != null) {
            final photoUrl = photoData['cloudinaryUrl'];
            print('🏠 Home: Setting profile photo URL: $photoUrl');
            setState(() {
              _profilePhotoUrl = photoUrl;
              _isLoadingProfilePhoto = false;
            });
          } else {
            print('🏠 Home: No photo URL found in response data');
            setState(() {
              _isLoadingProfilePhoto = false;
            });
          }
        } else {
          print('🏠 Home: No profile photo found for user');
          setState(() {
            _isLoadingProfilePhoto = false;
          });
        }
      } else {
        print('🏠 Home: Failed to fetch profile photo: ${result['message']}');
        setState(() {
          _isLoadingProfilePhoto = false;
        });
      }
    } catch (e) {
      print('🏠 Home: Error fetching profile photo: ${e.toString()}');
      setState(() {
        _isLoadingProfilePhoto = false;
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
                  trainingProgress: _trainingProgress,
                  readinessLevel: _combatReadiness,
                  cardColor: Colors.white,
                  profilePhotoUrl: _profilePhotoUrl,
                  isLoading: _isLoadingProgress,
                ),
            SizedBox(height: 12),
            _isLoadingStats
                ? const TrainingStatsSkeleton()
                : TrainingStatsWidget(),
            _isLoadingCareer
                ? const CareerProgressionSkeleton()
                : CareerProgressionCard(
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
                    PromotionRequirement(
                      label: 'Staff Endorsement',
                      passed: false,
                    ),
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
                      'My Training Programs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    _isLoadingPrograms
                        ? Column(
                          children: List.generate(
                            3,
                            (index) => const TrainingProgramSkeleton(),
                          ),
                        )
                        : _currentTrainingPrograms.isEmpty
                        ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.school_outlined,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No enrolled training programs',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Check the Training tab to enroll in programs',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                        : Column(
                          children:
                              _currentTrainingPrograms.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final program = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[50],
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                  program['name'] ??
                                                      'Unknown Program',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  'Instructor: ${program['instructor'] ?? 'Unknown'}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
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
                                              color: _getStatusBackgroundColor(
                                                program['status'] ?? '',
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: _getStatusBorderColor(
                                                  program['status'] ?? '',
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              _getStatusDisplayText(
                                                program['status'] ?? '',
                                              ),
                                              style: TextStyle(
                                                color: _getStatusTextColor(
                                                  program['status'] ?? '',
                                                ),
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
                                            '${(program['progress'] ?? 0.0).round()}%',
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
                                        value:
                                            (program['progress'] ?? 0.0) /
                                            100.0,
                                        minHeight: 5,
                                        backgroundColor: Colors.grey[200],
                                        color: Colors.green[700],
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Grade: ${program['grade'] ?? 'N/A'}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (program['nextSession'] != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4.0,
                                          ),
                                          child: Text(
                                            'Next Session: ${program['nextSession']}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      if (index <
                                          _currentTrainingPrograms.length - 1)
                                        Divider(
                                          height: 16,
                                          color: Colors.grey[300],
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
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

  // Helper methods for status styling
  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'in progress':
        return 'In Progress';
      case 'upcoming':
        return 'Upcoming';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.isNotEmpty
            ? '${status[0].toUpperCase()}${status.substring(1).toLowerCase()}'
            : 'Unknown';
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green.withOpacity(0.1);
      case 'in progress':
        return Colors.blue.withOpacity(0.1);
      case 'upcoming':
        return Colors.orange.withOpacity(0.1);
      case 'cancelled':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  Color _getStatusBorderColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green.withOpacity(0.3);
      case 'in progress':
        return Colors.blue.withOpacity(0.3);
      case 'upcoming':
        return Colors.orange.withOpacity(0.3);
      case 'cancelled':
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green[700]!;
      case 'in progress':
        return Colors.blue[700]!;
      case 'upcoming':
        return Colors.orange[700]!;
      case 'cancelled':
        return Colors.red[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}
