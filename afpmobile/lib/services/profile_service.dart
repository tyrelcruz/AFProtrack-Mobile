import '../models/user_profile.dart';
import 'api_service.dart';

class ProfileService {
  static UserProfile? _cachedProfile;
  static bool _isLoading = false;

  // Get current user profile from backend
  static Future<UserProfile?> getCurrentUserProfile() async {
    // Return cached data if available and not loading
    if (_cachedProfile != null && !_isLoading) {
      return _cachedProfile;
    }

    _isLoading = true;

    try {
      final response = await ApiService.getCurrentUser();

      if (response['success']) {
        final userData = response['data'];
        _cachedProfile = UserProfile.fromBackendResponse(userData);

        // Get training statistics to update completed programs and certificates
        await _updateTrainingStats();

        return _cachedProfile;
      } else {
        print('Failed to fetch user profile: ${response['message']}');
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    } finally {
      _isLoading = false;
    }
  }

  // Update user profile
  static Future<bool> updateUserProfile(UserProfile profile) async {
    try {
      final userData = profile.toBackendFormat();
      final response = await ApiService.updateUserProfile(profile.id, userData);

      if (response['success']) {
        // Update cached profile
        _cachedProfile = profile;
        return true;
      } else {
        print('Failed to update profile: ${response['message']}');
        return false;
      }
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // Update training statistics from training programs
  static Future<void> _updateTrainingStats() async {
    if (_cachedProfile == null) return;

    try {
      final statsResponse = await ApiService.getTrainingStatistics();

      if (statsResponse['success']) {
        final stats = statsResponse['data'];
        final completed = stats['completed'] ?? 0;
        final certificates = stats['certificates'] ?? 0;

        _cachedProfile = _cachedProfile!.copyWith(
          completedPrograms: completed,
          certificatesEarned: certificates,
        );
      }
    } catch (e) {
      print('Error updating training stats: $e');
    }
  }

  // Clear cache to force refresh
  static void clearCache() {
    _cachedProfile = null;
    _isLoading = false;
  }
}
