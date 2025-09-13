import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import '../models/user_profile.dart';
import '../models/military_org_data.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';
import '../utils/flushbar_utils.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import 'package:http_parser/http_parser.dart';

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
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _suffixController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _addressController;
  late TextEditingController _contactNumberController;
  late TextEditingController _emailController;
  late TextEditingController _alternateEmailController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ecNameController;
  late TextEditingController _ecAddressController;
  late TextEditingController _ecContactController;

  String? _bloodTypeValue;
  String? _relationshipValue;
  Branch? _selectedBranch;
  Division? _selectedDivision;
  Unit? _selectedUnit;
  Rank? _selectedRank;

  // Military organization data
  MilitaryOrgData? _militaryOrgData;
  List<Branch> _branches = [];
  List<Division> _divisions = [];
  List<Unit> _units = [];
  List<Rank> _ranks = [];

  // Loading states (removed - fetching is now silent)

  // Track shown guidance to prevent multiple popups
  bool _hasShownDivisionGuidance = false;
  bool _hasShownUnitGuidance = false;
  bool _hasShownRankGuidance = false;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingProfilePhoto = false;
  File? _selectedImageFile;
  String? _currentProfilePhotoUrl;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchUserProfilePhoto();
    _loadAllMilitaryOrgData();
  }

  void _initializeControllers() {
    // Split the name into first and last name
    final nameParts = widget.profile.name.split(' ');
    _firstNameController = TextEditingController(
      text: nameParts.isNotEmpty ? nameParts.first : '',
    );
    _lastNameController = TextEditingController(
      text: nameParts.length > 1 ? nameParts.skip(1).join(' ') : '',
    );
    _suffixController = TextEditingController(text: ''); // Default empty

    // Convert date enlisted to date of birth format (this might need adjustment)
    _dateOfBirthController = TextEditingController(
      text: widget.profile.dateEnlisted,
    );

    _addressController = TextEditingController(
      text: widget.profile.homeAddress,
    );
    _contactNumberController = TextEditingController(
      text: widget.profile.phone,
    );
    _emailController = TextEditingController(text: widget.profile.email);
    _alternateEmailController = TextEditingController(
      text: widget.profile.alternateEmail ?? '',
    );

    _bloodTypeValue = widget.profile.bloodType;

    _heightController = TextEditingController(
      text: widget.profile.heightMeters ?? '',
    );
    _weightController = TextEditingController(
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

    // Initialize dropdown selections
    _selectedBranch = null;
    _selectedDivision = null;
    _selectedUnit = null;
    _selectedRank = null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    _dateOfBirthController.dispose();
    _addressController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _alternateEmailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
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
                  controller: _firstNameController,
                  label: 'First Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _suffixController,
                  label: 'Suffix (Optional)',
                  icon: Icons.text_fields,
                  validator: null, // Optional field
                ),
                _buildTextField(
                  controller: _dateOfBirthController,
                  label: 'Date of Birth',
                  icon: Icons.calendar_today,
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your date of birth';
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
                _buildDropdown<Branch>(
                  label: 'Branch',
                  icon: Icons.flag,
                  value: _selectedBranch,
                  items: _branches,
                  onChanged: (v) {
                    print('🔄 Branch selected: ${v?.name} (ID: ${v?.id})');
                    setState(() {
                      _selectedBranch = v;
                    });
                    if (v != null) {
                      print(
                        '🔄 Loading divisions and ranks for branch: ${v.name} (${v.id})',
                      );
                      _loadDivisionsAndRanksForBranch(v);
                    } else {
                      setState(() {
                        _divisions = [];
                        _selectedDivision = null;
                        _units = [];
                        _selectedUnit = null;
                        _ranks = [];
                        _selectedRank = null;
                      });
                    }
                  },
                  validator:
                      (v) => v == null ? 'Please select your branch' : null,
                ),
                _buildDropdown<Division>(
                  label: 'Division',
                  icon: Icons.shield,
                  value: _selectedDivision,
                  items: _divisions,
                  isDisabled: _divisions.isEmpty,
                  onChanged: (v) {
                    setState(() {
                      _selectedDivision = v;
                    });
                    if (v != null && _selectedBranch != null) {
                      _loadUnitsForDivision(v);
                    } else {
                      setState(() {
                        _units = [];
                        _selectedUnit = null;
                      });
                    }
                  },
                  onTap:
                      _selectedBranch == null
                          ? () => _showGuidanceTooltip(
                            'Please select a Branch first to load available Divisions',
                            'division',
                          )
                          : null,
                  validator:
                      (v) => v == null ? 'Please select your division' : null,
                ),
                _buildDropdown<Unit>(
                  label: 'Unit',
                  icon: Icons.location_on,
                  value: _selectedUnit,
                  items: _units,
                  isDisabled: _units.isEmpty,
                  onChanged: (v) => setState(() => _selectedUnit = v),
                  onTap:
                      _selectedBranch == null || _selectedDivision == null
                          ? () => _showGuidanceTooltip(
                            'Please select a Branch and Division first to load available Units',
                            'unit',
                          )
                          : null,
                  validator:
                      (v) => v == null ? 'Please select your unit' : null,
                ),
                _buildDropdown<Rank>(
                  label: 'Rank',
                  icon: Icons.star,
                  value: _selectedRank,
                  items: _ranks,
                  isDisabled: _ranks.isEmpty,
                  onChanged: (v) => setState(() => _selectedRank = v),
                  onTap:
                      _selectedBranch == null
                          ? () => _showGuidanceTooltip(
                            'Please select a Branch first to load available Ranks',
                            'rank',
                          )
                          : null,
                  validator:
                      (v) => v == null ? 'Please select your rank' : null,
                ),
              ],
            ),

            SizedBox(height: ResponsiveUtils.isMobile(context) ? 16 : 20),

            _buildSectionCard(
              title: 'Contact Information',
              fields: [
                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  icon: Icons.home,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _contactNumberController,
                  label: 'Contact Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
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
                _buildTextField(
                  controller: _alternateEmailController,
                  label: 'Alternate Email Address (Optional)',
                  icon: Icons.alternate_email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
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
                  controller: _heightController,
                  label: 'Height (in cm)',
                  icon: Icons.height,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your height in centimeters';
                    }
                    final v = double.tryParse(value);
                    if (v == null || v <= 0) {
                      return 'Enter a valid height in centimeters';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _weightController,
                  label: 'Weight (in kg)',
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
                    'Spouse',
                    'Parent',
                    'Sibling',
                    'Child',
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
                      _isLoadingProfilePhoto
                          ? Center(
                            child: SizedBox(
                              width: profileIconSize * 0.5,
                              height: profileIconSize * 0.5,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.armyPrimary,
                                ),
                              ),
                            ),
                          )
                          : _selectedImageFile != null
                          ? ClipOval(
                            child: Image.file(
                              _selectedImageFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                          : _currentProfilePhotoUrl != null
                          ? ClipOval(
                            child: Image.network(
                              _currentProfilePhotoUrl!,
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
                          : widget.profile.profilePictureUrl != null
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
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: readOnly ? Colors.grey : AppColors.armyPrimary,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: readOnly ? Colors.grey : AppColors.cardBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: readOnly ? Colors.grey : AppColors.cardBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: readOnly ? Colors.grey : AppColors.armyPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: readOnly ? Colors.grey[100] : Colors.grey[50],
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
    VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    // Safety check: ensure the current value exists in the items list
    T? safeValue = value;
    if (value != null && !items.contains(value)) {
      print('⚠️ Invalid value detected for $label: $value, clearing selection');
      safeValue = null;
    }

    return GestureDetector(
      onTap: onTap,
      child: DropdownButtonFormField<T>(
        value: safeValue,
        hint: Text(
          isDisabled ? 'No $label available' : 'Select $label',
          overflow: TextOverflow.ellipsis,
        ),
        items:
            items.map((e) {
              return DropdownMenuItem<T>(
                value: e,
                child: Container(
                  width: double.infinity,
                  child: Text(
                    e.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            }).toList(),
        onChanged: isDisabled ? null : onChanged,
        validator: validator,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: isDisabled ? Colors.grey : AppColors.armyPrimary,
          ),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.cardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDisabled ? Colors.grey[300]! : AppColors.cardBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDisabled ? Colors.grey[300]! : AppColors.armyPrimary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: isDisabled ? Colors.grey[100] : Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.isMobile(context) ? 10 : 14,
            vertical: ResponsiveUtils.isMobile(context) ? 10 : 12,
          ),
        ),
      ),
    );
  }

  int? _parseHeight(String heightString) {
    if (heightString.isEmpty) return null;

    final height = double.tryParse(heightString);
    if (height == null) return null;

    // Backend expects height in cm as integer
    // If user enters in meters (e.g., 1.75), convert to cm
    if (height < 10) {
      // Likely entered in meters, convert to cm
      return (height * 100).round();
    } else {
      // Likely entered in cm, use as is
      return height.round();
    }
  }

  int? _parseWeight(String weightString) {
    if (weightString.isEmpty) return null;

    final weight = double.tryParse(weightString);
    if (weight == null) return null;

    // Backend expects weight as integer
    final weightInt = weight.round();

    // Weight should be reasonable (between 30-200 kg)
    if (weightInt < 30 || weightInt > 200) {
      print('⚠️ Unusual weight value: $weightInt kg');
    }

    return weightInt;
  }

  bool _validateRequiredFields(Map<String, dynamic> data) {
    final requiredFields = [
      'firstName',
      'lastName',
      'address',
      'contactNumber',
      'branchId',
      'divisionId',
      'unitId',
      'rankId',
      'bloodType',
      'emergencyContactName',
      'emergencyContactRelationship',
      'emergencyContactAddress',
      'emergencyContactNumber',
    ];

    for (final field in requiredFields) {
      final value = data[field];
      if (value == null || value.toString().trim().isEmpty) {
        print('❌ Missing required field: $field');
        return false;
      }
    }

    return true;
  }

  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/png';
    }
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
          title: const Text('Change Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline),
                title: const Text('Remove Current Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _removeProfilePhoto();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Check if image picker is available
      final ImagePicker picker = ImagePicker();

      // Add a small delay to ensure the picker is properly initialized
      await Future.delayed(const Duration(milliseconds: 100));

      final XFile? image = await picker
          .pickImage(
            source: source,
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Image picker timed out. Please try again.');
            },
          );

      if (image != null) {
        setState(() {
          _selectedImageFile = File(image.path);
        });
        await _uploadProfilePhoto(File(image.path));
      }
    } on PlatformException catch (e) {
      String errorMessage = 'Failed to pick image';

      switch (e.code) {
        case 'camera_access_denied':
          errorMessage =
              'Camera access denied. Please grant camera permission.';
          break;
        case 'photo_access_denied':
          errorMessage =
              'Gallery access denied. Please grant photo permission.';
          break;
        case 'channel-error':
          errorMessage =
              'Image picker not available. Please try again or restart the app.';
          break;
        default:
          errorMessage = 'Error picking image: ${e.message}';
      }

      FlushbarUtils.showError(
        context,
        message: errorMessage,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      FlushbarUtils.showError(
        context,
        message: 'Error picking image: ${e.toString()}',
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _uploadProfilePhoto(File imageFile) async {
    try {
      setState(() {
        _isLoadingProfilePhoto = true;
      });

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        },
      );

      // Read the image file as bytes
      final bytes = await imageFile.readAsBytes();
      final fileName = imageFile.path.split('/').last;
      final fileSize = bytes.length;

      // Debug information
      print('Uploading file: $fileName');
      print('File size: $fileSize bytes');
      print('File path: ${imageFile.path}');
      print('File extension: ${fileName.split('.').last.toLowerCase()}');

      // Validate file size
      if (fileSize > 10 * 1024 * 1024) {
        // 10MB limit
        throw Exception('File size too large. Maximum size is 10MB.');
      }

      // Validate file extension
      final fileExtension = fileName.split('.').last.toLowerCase();
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
      if (!allowedExtensions.contains(fileExtension)) {
        throw Exception(
          'Invalid file type. Allowed types: ${allowedExtensions.join(', ')}',
        );
      }

      // Check if file exists and is readable
      if (!await imageFile.exists()) {
        throw Exception('File does not exist or is not accessible');
      }

      // Create multipart request for file upload using the correct route
      final uri = Uri.parse(
        '${ApiService.baseUrl}/upload/profile-photo/direct',
      );
      final request = http.MultipartRequest('POST', uri);

      // Add authorization header
      final token = await TokenService.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Determine the correct MIME type based on file extension
      final mimeType = _getMimeType(fileName);
      print('Using MIME type: $mimeType');

      // Add the file with the correct field name 'file' and proper MIME type
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      );

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Debug response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Hide loading indicator
      Navigator.of(context).pop();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          // Update the profile picture in the UI
          setState(() {
            _currentProfilePhotoUrl = data['data']['cloudinaryUrl'];
            _isLoadingProfilePhoto = false;
          });

          // Update the profile with the new photo URL
          widget.profile.copyWith(
            profilePictureUrl: data['data']['cloudinaryUrl'],
          );

          FlushbarUtils.showSuccess(
            context,
            message: data['message'] ?? 'Profile photo uploaded successfully',
            duration: const Duration(seconds: 3),
          );

          print(
            'Profile photo uploaded successfully. Photo URL: ${data['data']['cloudinaryUrl']}',
          );
        } else {
          setState(() {
            _isLoadingProfilePhoto = false;
          });

          FlushbarUtils.showError(
            context,
            message: data['message'] ?? 'Failed to upload profile photo',
            duration: const Duration(seconds: 4),
          );
        }
      } else {
        setState(() {
          _isLoadingProfilePhoto = false;
        });

        final data = jsonDecode(response.body);
        FlushbarUtils.showError(
          context,
          message:
              data['message'] ??
              'Failed to upload profile photo (Status: ${response.statusCode})',
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      // Hide loading indicator
      Navigator.of(context).pop();

      setState(() {
        _isLoadingProfilePhoto = false;
      });

      print('Upload error: ${e.toString()}');

      FlushbarUtils.showError(
        context,
        message: 'Error uploading profile photo: ${e.toString()}',
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _fetchUserProfilePhoto() async {
    setState(() {
      _isLoadingProfilePhoto = true;
    });

    try {
      print('🔄 Fetching user profile photo...');
      final result = await ApiService.getUserProfilePhoto();

      print('🔄 Profile photo result: $result');

      if (result['success']) {
        if (result['data'] != null) {
          final photoData = result['data'];
          print('🔄 Photo data received: $photoData');

          if (photoData['cloudinaryUrl'] != null) {
            final photoUrl = photoData['cloudinaryUrl'];
            print('🔄 Setting profile photo URL: $photoUrl');
            setState(() {
              _currentProfilePhotoUrl = photoUrl;
            });

            // Also update the widget's profile data if available
            widget.profile.copyWith(profilePictureUrl: photoUrl);
            print('🔄 Profile updated with new photo URL');
          } else {
            print('🔄 No photo URL found in response data');
          }
        } else {
          print('🔄 No profile photo found for user');
        }
      } else {
        print('🔄 Failed to fetch profile photo: ${result['message']}');
        if (result['statusCode'] != null) {
          print('🔄 Status code: ${result['statusCode']}');
        }
      }
    } catch (e) {
      // Log error but don't show to user - profile photo is optional
      print('🔄 Error fetching profile photo: ${e.toString()}');
    } finally {
      setState(() {
        _isLoadingProfilePhoto = false;
      });
    }
  }

  Future<void> _removeProfilePhoto() async {
    try {
      setState(() {
        _isLoadingProfilePhoto = true;
        _selectedImageFile = null;
        _currentProfilePhotoUrl = null;
      });

      // Call API to remove profile photo
      final result = await ApiService.removeUserProfilePhoto();

      if (result['success']) {
        // Update the profile data
        widget.profile.copyWith(profilePictureUrl: null);

        FlushbarUtils.showSuccess(
          context,
          message: 'Profile photo removed successfully',
          duration: const Duration(seconds: 3),
        );
      } else {
        FlushbarUtils.showError(
          context,
          message: result['message'] ?? 'Failed to remove profile photo',
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      FlushbarUtils.showError(
        context,
        message: 'Error removing profile photo: ${e.toString()}',
        duration: const Duration(seconds: 3),
      );
    } finally {
      setState(() {
        _isLoadingProfilePhoto = false;
      });
    }
  }

  // Load all military organization data
  Future<void> _loadAllMilitaryOrgData() async {
    try {
      print('🔄 Loading all military organization data...');
      final result = await ApiService.getAllMilitaryOrgData();

      if (result['success']) {
        final data = result['data'];
        print(
          '🔄 Raw API data received: ${data.toString().substring(0, 200)}...',
        );

        try {
          _militaryOrgData = MilitaryOrgData.fromJson(data);

          setState(() {
            _branches = _militaryOrgData!.branches;
          });

          print('🔄 Loaded ${_branches.length} branches');

          // Try to match existing profile data with the loaded data
          _matchExistingProfileData();
        } catch (e) {
          print('❌ Error parsing military org data: $e');
          FlushbarUtils.showError(
            context,
            message:
                'Error parsing military organization data: ${e.toString()}',
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        print('❌ Failed to load military org data: ${result['message']}');
        FlushbarUtils.showError(
          context,
          message:
              'Failed to load military organization data: ${result['message']}',
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('❌ Error loading military org data: $e');
      FlushbarUtils.showError(
        context,
        message: 'Error loading military organization data: ${e.toString()}',
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Match existing profile data with loaded military org data
  void _matchExistingProfileData() {
    if (_militaryOrgData == null) return;

    // Try to match branch
    final branchName = widget.profile.branch;
    if (branchName.isNotEmpty) {
      _selectedBranch = _branches.firstWhere(
        (branch) => branch.name == branchName,
        orElse: () => _branches.first,
      );

      if (_selectedBranch != null) {
        // Load divisions and ranks for the matched branch
        _loadDivisionsAndRanksForBranch(_selectedBranch!);

        // Try to match division (UserProfile doesn't have division, so we'll skip this)
        final divisionName = null; // widget.profile.division;
        if (divisionName != null && divisionName.isNotEmpty) {
          try {
            _selectedDivision = _selectedBranch!.divisions.firstWhere(
              (division) => division.name == divisionName,
            );
          } catch (e) {
            _selectedDivision =
                _selectedBranch!.divisions.isNotEmpty
                    ? _selectedBranch!.divisions.first
                    : null;
          }

          if (_selectedDivision != null) {
            // Load units for the matched division
            _loadUnitsForDivision(_selectedDivision!);

            // Try to match unit
            final unitName = widget.profile.unit;
            if (unitName.isNotEmpty) {
              try {
                _selectedUnit = _selectedDivision!.units.firstWhere(
                  (unit) => unit.name == unitName,
                );
              } catch (e) {
                _selectedUnit =
                    _selectedDivision!.units.isNotEmpty
                        ? _selectedDivision!.units.first
                        : null;
              }
            }
          }
        }

        // Try to match rank
        final rankName = widget.profile.rank;
        if (rankName.isNotEmpty) {
          try {
            _selectedRank = _selectedBranch!.ranks.firstWhere(
              (rank) => rank.name == rankName,
            );
          } catch (e) {
            _selectedRank =
                _selectedBranch!.ranks.isNotEmpty
                    ? _selectedBranch!.ranks.first
                    : null;
          }
        }
      }
    }
  }

  // Load divisions and ranks for a specific branch
  void _loadDivisionsAndRanksForBranch(Branch branch) {
    print('🔄 Loading divisions and ranks for branch: ${branch.name}');
    print('🔄 Divisions count: ${branch.divisions.length}');
    print('🔄 Ranks count: ${branch.ranks.length}');

    setState(() {
      _divisions = branch.divisions;
      _ranks = branch.ranks;
      // Clear ALL dependent selections to prevent invalid values
      _selectedDivision = null;
      _selectedUnit = null;
      _selectedRank = null; // Clear rank selection too!
      _units = [];
    });

    // Debug: Check for duplicate rank names
    final rankNames = _ranks.map((r) => r.name).toList();
    final uniqueRankNames = rankNames.toSet();
    if (rankNames.length != uniqueRankNames.length) {
      print('⚠️ Duplicate rank names detected in ${branch.name}:');
      final duplicates =
          rankNames
              .where(
                (name) =>
                    rankNames.indexOf(name) != rankNames.lastIndexOf(name),
              )
              .toSet();
      for (final duplicate in duplicates) {
        print(
          '   - "$duplicate" appears ${rankNames.where((n) => n == duplicate).length} times',
        );
      }
    }

    print(
      '🔄 Updated state - divisions: ${_divisions.length}, ranks: ${_ranks.length}',
    );
  }

  // Load units for a specific division
  void _loadUnitsForDivision(Division division) {
    print('🔄 Loading units for division: ${division.name}');
    print('🔄 Units count: ${division.units.length}');

    setState(() {
      _units = division.units;
      // Clear dependent selection
      _selectedUnit = null;
    });

    print('🔄 Updated state - units: ${_units.length}');
  }

  // Show guidance tooltip for dependent dropdowns (only once per session)
  void _showGuidanceTooltip(String message, String guidanceType) {
    bool hasShown = false;

    switch (guidanceType) {
      case 'division':
        hasShown = _hasShownDivisionGuidance;
        if (!hasShown) _hasShownDivisionGuidance = true;
        break;
      case 'unit':
        hasShown = _hasShownUnitGuidance;
        if (!hasShown) _hasShownUnitGuidance = true;
        break;
      case 'rank':
        hasShown = _hasShownRankGuidance;
        if (!hasShown) _hasShownRankGuidance = true;
        break;
    }

    if (!hasShown) {
      FlushbarUtils.showInfo(
        context,
        message: message,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare data for the new API format
      final profileData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'suffix':
            _suffixController.text.trim().isEmpty
                ? null
                : _suffixController.text.trim(),
        'address': _addressController.text.trim(),
        'contactNumber': _contactNumberController.text.trim(),
        'alternateEmail':
            _alternateEmailController.text.trim().isEmpty
                ? null
                : _alternateEmailController.text.trim(),
        'branchId': _selectedBranch?.id ?? '',
        'divisionId': _selectedDivision?.id ?? '',
        'unitId': _selectedUnit?.id ?? '',
        'rankId': _selectedRank?.id ?? '',
        'bloodType': _bloodTypeValue ?? '',
        'height': _parseHeight(_heightController.text.trim()),
        'weight': _parseWeight(_weightController.text.trim()),
        'emergencyContactName': _ecNameController.text.trim(),
        'emergencyContactRelationship': _relationshipValue ?? '',
        'emergencyContactAddress': _ecAddressController.text.trim(),
        'emergencyContactNumber': _ecContactController.text.trim(),
      };

      print('🔄 Sending profile update data: $profileData');
      print('🔄 Branch ID: ${_selectedBranch?.id} (${_selectedBranch?.name})');
      print(
        '🔄 Division ID: ${_selectedDivision?.id} (${_selectedDivision?.name})',
      );
      print('🔄 Unit ID: ${_selectedUnit?.id} (${_selectedUnit?.name})');
      print('🔄 Rank ID: ${_selectedRank?.id} (${_selectedRank?.name})');
      print('🔄 Height: ${_parseHeight(_heightController.text.trim())}');
      print('🔄 Weight: ${_parseWeight(_weightController.text.trim())}');
      print('🔄 Raw height input: "${_heightController.text.trim()}"');
      print('🔄 Raw weight input: "${_weightController.text.trim()}"');
      print(
        '🔄 All required fields present: ${_validateRequiredFields(profileData)}',
      );

      // Call the new API method
      final result = await ApiService.updateUserProfileMobile(profileData);

      if (result['success']) {
        // Create updated profile for local state
        final fullName =
            '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
                .trim();
        final updatedProfile = widget.profile.copyWith(
          name: fullName,
          email: _emailController.text.trim(),
          phone: _contactNumberController.text.trim(),
          homeAddress: _addressController.text.trim(),
          alternateEmail:
              _alternateEmailController.text.trim().isEmpty
                  ? null
                  : _alternateEmailController.text.trim(),
          bloodType: _bloodTypeValue,
          heightMeters: _heightController.text.trim(),
          weightKg: _weightController.text.trim(),
          emergencyContact: EmergencyContact(
            fullName: _ecNameController.text.trim(),
            address: _ecAddressController.text.trim(),
            contactNumber: _ecContactController.text.trim(),
            relationship: _relationshipValue ?? '',
          ),
        );

        // Show success message
        FlushbarUtils.showSuccess(
          context,
          message: result['message'] ?? 'Profile updated successfully',
          duration: const Duration(seconds: 3),
        );

        // Call the save callback
        widget.onSave(updatedProfile);
      } else {
        // Show detailed error message
        final errorMessage = result['message'] ?? 'Unknown error';
        final errors = result['errors'];

        print('❌ Profile update failed: $errorMessage');
        if (errors != null) {
          print('❌ Detailed errors: $errors');
        }

        // Additional debugging for military org data
        print('🔍 Debugging military org data:');
        print('   Branch: ${_selectedBranch?.name} (${_selectedBranch?.id})');
        print(
          '   Division: ${_selectedDivision?.name} (${_selectedDivision?.id})',
        );
        print('   Unit: ${_selectedUnit?.name} (${_selectedUnit?.id})');
        print('   Rank: ${_selectedRank?.name} (${_selectedRank?.id})');

        FlushbarUtils.showError(
          context,
          message: 'Failed to update profile: $errorMessage',
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      // Show error message
      FlushbarUtils.showError(
        context,
        message: 'Failed to update profile: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
