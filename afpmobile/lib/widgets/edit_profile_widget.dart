import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';

class EditProfileWidget extends StatefulWidget {
  final UserProfile profile;
  final Function(UserProfile) onSave;
  final VoidCallback onCancel;

  const EditProfileWidget({
    Key? key,
    required this.profile,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late TextEditingController _nameController;
  late TextEditingController _rankController;
  late TextEditingController _serviceIdController;
  late TextEditingController _unitController;
  late TextEditingController _branchController;
  late TextEditingController _currentBaseController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dateEnlistedController;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.profile.name);
    _rankController = TextEditingController(text: widget.profile.rank);
    _serviceIdController = TextEditingController(
      text: widget.profile.serviceId,
    );
    _unitController = TextEditingController(text: widget.profile.unit);
    _branchController = TextEditingController(text: widget.profile.branch);
    _currentBaseController = TextEditingController(
      text: widget.profile.currentBase,
    );
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _dateEnlistedController = TextEditingController(
      text: widget.profile.dateEnlisted,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rankController.dispose();
    _serviceIdController.dispose();
    _unitController.dispose();
    _branchController.dispose();
    _currentBaseController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateEnlistedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = ResponsiveUtils.getResponsivePadding(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            _buildProfilePictureSection(),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 20 : 24),

            // Personal Information Section
            _buildSectionHeader('Personal Information'),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 12 : 16),
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 12 : 16),
            _buildTextField(
              controller: _rankController,
              label: 'Rank',
              icon: Icons.star,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your rank';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 12 : 16),
            _buildTextField(
              controller: _serviceIdController,
              label: 'Service ID',
              icon: Icons.badge,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your service ID';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 12 : 16),
            _buildTextField(
              controller: _dateEnlistedController,
              label: 'Date Enlisted',
              icon: Icons.calendar_today,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your enlistment date';
                }
                return null;
              },
            ),

            SizedBox(height: ResponsiveUtils.isMobile(context) ? 24 : 32),

            // Service Information Section
            _buildSectionHeader('Service Information'),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 12 : 16),
            _buildTextField(
              controller: _unitController,
              label: 'Unit',
              icon: Icons.shield,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your unit';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 12 : 16),
            _buildTextField(
              controller: _branchController,
              label: 'Branch',
              icon: Icons.flag,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your branch';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 12 : 16),
            _buildTextField(
              controller: _currentBaseController,
              label: 'Current Base',
              icon: Icons.location_on,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your current base';
                }
                return null;
              },
            ),

            SizedBox(height: ResponsiveUtils.isMobile(context) ? 24 : 32),

            // Contact Information Section
            _buildSectionHeader('Contact Information'),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 12 : 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 12 : 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),

            SizedBox(height: ResponsiveUtils.isMobile(context) ? 32 : 40),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    final profilePictureSize = ResponsiveUtils.isMobile(context) ? 80.0 : 100.0;
    final profileIconSize = ResponsiveUtils.isMobile(context) ? 45.0 : 55.0;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _showProfilePictureDialog,
            child: Stack(
              children: [
                Container(
                  width: profilePictureSize,
                  height: profilePictureSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.black, width: 2),
                    color: Colors.grey[100],
                  ),
                  child:
                      widget.profile.profilePictureUrl != null
                          ? ClipOval(
                            child: Image.network(
                              widget.profile.profilePictureUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: profileIconSize,
                                  color: AppColors.black,
                                );
                              },
                            ),
                          )
                          : Icon(
                            Icons.person,
                            size: profileIconSize,
                            color: AppColors.black,
                          ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.armyPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: ResponsiveUtils.isMobile(context) ? 16 : 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveUtils.isMobile(context) ? 8 : 12),
          Text(
            'Tap to change photo',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                mobile: 14,
                tablet: 15,
                desktop: 16,
              ),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: ResponsiveUtils.getResponsiveFontSize(
          context,
          mobile: 18,
          tablet: 20,
          desktop: 22,
        ),
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.armyPrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.armyPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.isMobile(context) ? 12 : 16,
          vertical: ResponsiveUtils.isMobile(context) ? 14 : 16,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Cancel Button
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : widget.onCancel,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.cardBorder),
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.isMobile(context) ? 14 : 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  mobile: 16,
                  tablet: 16,
                  desktop: 16,
                ),
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(width: ResponsiveUtils.isMobile(context) ? 12 : 16),
        // Save Button
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.armyPrimary,
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.isMobile(context) ? 14 : 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                _isLoading
                    ? SizedBox(
                      height: ResponsiveUtils.isMobile(context) ? 16 : 18,
                      width: ResponsiveUtils.isMobile(context) ? 16 : 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          mobile: 16,
                          tablet: 16,
                          desktop: 16,
                        ),
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  void _showProfilePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement camera functionality
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement gallery picker functionality
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create updated profile
      final updatedProfile = widget.profile.copyWith(
        name: _nameController.text.trim(),
        rank: _rankController.text.trim(),
        serviceId: _serviceIdController.text.trim(),
        unit: _unitController.text.trim(),
        branch: _branchController.text.trim(),
        currentBase: _currentBaseController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        dateEnlisted: _dateEnlistedController.text.trim(),
      );

      // Call the save callback
      widget.onSave(updatedProfile);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
