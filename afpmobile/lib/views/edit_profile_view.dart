import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/edit_profile_widget.dart';
import '../utils/app_colors.dart';

class EditProfileView extends StatefulWidget {
  final UserProfile profile;

  const EditProfileView({super.key, required this.profile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late UserProfile _currentProfile;

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const AppBarWidget(title: 'Edit Profile', showLeading: true),
      body: EditProfileWidget(
        profile: _currentProfile,
        onSave: _handleProfileSave,
        onCancel: _handleCancel,
      ),
    );
  }

  void _handleProfileSave(UserProfile updatedProfile) {
    setState(() {
      _currentProfile = updatedProfile;
    });

    // TODO: Here you would typically:
    // 1. Save the profile to your backend/API
    // 2. Update local storage
    // 3. Update any global state management

    // For now, we'll just navigate back to the profile view
    Navigator.of(context).pop(updatedProfile);
  }

  void _handleCancel() {
    // Show confirmation dialog if there are unsaved changes
    if (_hasUnsavedChanges()) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.of(context).pop();
    }
  }

  bool _hasUnsavedChanges() {
    return _currentProfile.name != widget.profile.name ||
        _currentProfile.rank != widget.profile.rank ||
        _currentProfile.serviceId != widget.profile.serviceId ||
        _currentProfile.unit != widget.profile.unit ||
        _currentProfile.branch != widget.profile.branch ||
        _currentProfile.currentBase != widget.profile.currentBase ||
        _currentProfile.email != widget.profile.email ||
        _currentProfile.phone != widget.profile.phone ||
        _currentProfile.dateEnlisted != widget.profile.dateEnlisted;
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unsaved Changes'),
          content: Text(
            'You have unsaved changes. Are you sure you want to discard them?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Discard', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
