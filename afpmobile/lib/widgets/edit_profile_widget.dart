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
  late TextEditingController _homeAddressController;
  late TextEditingController _alternateEmailController;
  late TextEditingController _heightMetersController;
  late TextEditingController _weightKgController;
  late TextEditingController _ecNameController;
  late TextEditingController _ecAddressController;
  late TextEditingController _ecContactController;

  String? _maritalStatusValue;
  String? _bloodTypeValue;
  String? _relationshipValue;

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
    _homeAddressController = TextEditingController(
      text: widget.profile.homeAddress,
    );
    _alternateEmailController = TextEditingController(
      text: widget.profile.alternateEmail ?? '',
    );
    _maritalStatusValue = widget.profile.maritalStatus;
    _bloodTypeValue = widget.profile.bloodType;
    _heightMetersController = TextEditingController(
      text: widget.profile.heightMeters ?? '',
    );
    _weightKgController = TextEditingController(
      text: widget.profile.weightKg ?? '',
    );
    _ecNameController = TextEditingController(
      text: widget.profile.emergencyContact?.fullName ?? '',
    );
    _ecAddressController = TextEditingController(
      text: widget.profile.emergencyContact?.address ?? '',
    );
    _ecContactController = TextEditingController(
      text: widget.profile.emergencyContact?.contactNumber ?? '',
    );
    _relationshipValue = widget.profile.emergencyContact?.relationship;
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
    _homeAddressController.dispose();
    _alternateEmailController.dispose();
    _heightMetersController.dispose();
    _weightKgController.dispose();
    _ecNameController.dispose();
    _ecAddressController.dispose();
    _ecContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildSectionCard(
              title: 'Personal Information',
              fields: [
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
              ],
            ),

            SizedBox(height: ResponsiveUtils.isMobile(context) ? 16 : 20),

            _buildSectionCard(
              title: 'Service Information',
              fields: [
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
              ],
            ),

            SizedBox(height: ResponsiveUtils.isMobile(context) ? 16 : 20),

            _buildSectionCard(
              title: 'Contact Information',
              fields: [
                _buildTextField(
                  controller: _homeAddressController,
                  label: 'Home Address',
                  icon: Icons.home,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your home address';
                    }
                    return null;
                  },
                ),
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
                      r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
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
                _buildTextField(
                  controller: _alternateEmailController,
                  label: 'Alternate Email Address (Optional)',
                  icon: Icons.alternate_email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (!RegExp(
                        r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid alternate email';
                      }
                    }
                    return null;
                  },
                ),
              ],
            ),

            SizedBox(height: ResponsiveUtils.isMobile(context) ? 16 : 20),

            _buildSectionCard(
              title: 'Additional Information',
              fields: [
                _buildDropdown<String>(
                  label: 'Status',
                  icon: Icons.people_outline,
                  value: _maritalStatusValue,
                  items: const [
                    'Single',
                    'Married',
                    'Separated',
                    'Widowed',
                    'Annulled',
                    'Divorced',
                  ],
                  onChanged: (v) => setState(() => _maritalStatusValue = v),
                  validator:
                      (v) =>
                          (v == null || v.isEmpty)
                              ? 'Please select your status'
                              : null,
                ),
                _buildDropdown<String>(
                  label: 'Blood Type',
                  icon: Icons.bloodtype,
                  value: _bloodTypeValue,
                  items: const [
                    'A+',
                    'A-',
                    'B+',
                    'B-',
                    'AB+',
                    'AB-',
                    'O+',
                    'O-',
                  ],
                  onChanged: (v) => setState(() => _bloodTypeValue = v),
                  validator:
                      (v) =>
                          (v == null || v.isEmpty)
                              ? 'Please select your blood type'
                              : null,
                ),
                _buildTextField(
                  controller: _heightMetersController,
                  label: 'Height (in meters)',
                  icon: Icons.height,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your height in meters';
                    }
                    final v = double.tryParse(value);
                    if (v == null || v <= 0) {
                      return 'Enter a valid height in meters';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _weightKgController,
                  label: 'Weight (in kilograms)',
                  icon: Icons.monitor_weight,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your weight in kilograms';
                    }
                    final v = double.tryParse(value);
                    if (v == null || v <= 0) {
                      return 'Enter a valid weight in kilograms';
                    }
                    return null;
                  },
                ),
              ],
            ),

            SizedBox(height: ResponsiveUtils.isMobile(context) ? 16 : 20),

            _buildSectionCard(
              title: 'Emergency Contact',
              fields: [
                _buildTextField(
                  controller: _ecNameController,
                  label: 'Complete Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a contact name';
                    }
                    return null;
                  },
                ),
                _buildDropdown<String>(
                  label: 'Relationship',
                  icon: Icons.family_restroom,
                  value: _relationshipValue,
                  items: const [
                    'Father',
                    'Mother',
                    'Sibling',
                    'Husband',
                    'Wife',
                    'Relative',
                    'Friend',
                    'Other',
                  ],
                  onChanged: (v) => setState(() => _relationshipValue = v),
                  validator:
                      (v) =>
                          (v == null || v.isEmpty)
                              ? 'Please select a relationship'
                              : null,
                ),
                _buildTextField(
                  controller: _ecAddressController,
                  label: 'Address',
                  icon: Icons.location_on_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _ecContactController,
                  label: 'Contact Number',
                  icon: Icons.phone_iphone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a contact number';
                    }
                    return null;
                  },
                ),
              ],
            ),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> fields,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.cardBorder, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveUtils.getResponsivePadding(
            context,
            mobile: 10,
            tablet: 14,
            desktop: 14,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  mobile: 18,
                  tablet: 18,
                  desktop: 18,
                ),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 8 : 10),
            Container(height: 1, color: Colors.grey[300]),
            SizedBox(height: ResponsiveUtils.isMobile(context) ? 10 : 12),
            _buildTwoColumn(fields),
          ],
        ),
      ),
    );
  }

  Widget _buildTwoColumn(List<Widget> fields) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns =
            width >= 420 ? 2 : 1; // 2 columns on wider phones/tablets
        final spacing = columns == 2 ? 12.0 : 8.0;
        final itemWidth = (width - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children:
              fields
                  .map(
                    (w) => SizedBox(
                      width: columns == 1 ? width : itemWidth,
                      child: w,
                    ),
                  )
                  .toList(),
        );
      },
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

  // Removed legacy _buildSectionHeader in favor of _buildSectionCard

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
        isDense: true,
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
          horizontal: ResponsiveUtils.isMobile(context) ? 10 : 14,
          vertical: ResponsiveUtils.isMobile(context) ? 10 : 12,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required List<T> items,
    required T? value,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items:
          items
              .map(
                (e) => DropdownMenuItem<T>(value: e, child: Text(e.toString())),
              )
              .toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.armyPrimary),
        isDense: true,
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
          horizontal: ResponsiveUtils.isMobile(context) ? 10 : 14,
          vertical: ResponsiveUtils.isMobile(context) ? 10 : 12,
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
        homeAddress: _homeAddressController.text.trim(),
        alternateEmail:
            _alternateEmailController.text.trim().isEmpty
                ? null
                : _alternateEmailController.text.trim(),
        maritalStatus: _maritalStatusValue,
        bloodType: _bloodTypeValue,
        heightMeters: _heightMetersController.text.trim(),
        weightKg: _weightKgController.text.trim(),
        emergencyContact: EmergencyContact(
          fullName: _ecNameController.text.trim(),
          address: _ecAddressController.text.trim(),
          contactNumber: _ecContactController.text.trim(),
          relationship: _relationshipValue ?? '',
        ),
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
