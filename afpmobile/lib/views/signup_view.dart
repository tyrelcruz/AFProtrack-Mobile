import 'package:flutter/material.dart';
import 'package:iconify_design/iconify_design.dart';
import '../utils/app_colors.dart';

import 'login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Form controllers for Step 1
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _suffixController = TextEditingController();
  final TextEditingController _serviceIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Form controllers for Step 2
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _divisionController = TextEditingController();

  // Store form data
  Map<String, dynamic> _formData = {};

  @override
  void dispose() {
    _nameController.dispose();
    _suffixController.dispose();
    _serviceIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _contactNoController.dispose();
    _streetAddressController.dispose();
    _unitController.dispose();
    _branchController.dispose();
    _divisionController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return _buildStep1();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create your Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.armyPrimary,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          'Step ${_currentStep + 1}: Basic Account Information',
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.grayText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 22),
        // Name and Suffix fields in a row
        Row(
          children: [
            // Name field (expanded)
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColors.armyPrimary,
                    ),
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: AppColors.armySecondary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.armyPrimary,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.armyPrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Suffix field (smaller)
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _suffixController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.text_fields,
                      color: AppColors.armyPrimary,
                    ),
                    labelText: 'Suffix',
                    hintText: 'Jr., Sr., III, etc.',
                    labelStyle: TextStyle(color: AppColors.armySecondary),
                    hintStyle: TextStyle(
                      color: AppColors.grayText.withOpacity(0.6),
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.armyPrimary,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.armyPrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Email field
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email, color: AppColors.armyPrimary),
              labelText: 'Email Address',
              labelStyle: TextStyle(color: AppColors.armySecondary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Password field
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, color: AppColors.armyPrimary),
              labelText: 'Password',
              labelStyle: TextStyle(color: AppColors.armySecondary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Confirm Password field
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock_outline,
                color: AppColors.armyPrimary,
              ),
              labelText: 'Confirm Password',
              labelStyle: TextStyle(color: AppColors.armySecondary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive breakpoints
            bool isSmallScreen = constraints.maxWidth < 400;
            bool isMediumScreen =
                constraints.maxWidth >= 400 && constraints.maxWidth < 600;
            bool isLargeScreen = constraints.maxWidth >= 600;

            // Adjust button height and font size based on screen size
            double buttonHeight =
                isSmallScreen
                    ? 44
                    : isMediumScreen
                    ? 48
                    : 52;
            double fontSize =
                isSmallScreen
                    ? 16
                    : isMediumScreen
                    ? 18
                    : 20;

            return SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.armyPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create your Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.armyPrimary,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          'Step ${_currentStep + 1}: Service & Contact Information',
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.grayText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 22),
        // Service ID field
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _serviceIdController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.badge, color: AppColors.armyPrimary),
              labelText: 'Service ID',
              labelStyle: TextStyle(color: AppColors.armySecondary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Contact Number field
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _contactNoController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone, color: AppColors.armyPrimary),
              labelText: 'Contact Number',
              labelStyle: TextStyle(color: AppColors.armySecondary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Street Address field
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _streetAddressController,
            maxLines: 2,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_on, color: AppColors.armyPrimary),
              labelText: 'Street Address',
              labelStyle: TextStyle(color: AppColors.armySecondary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Unit field
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _unitController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.group, color: AppColors.armyPrimary),
              labelText: 'Unit',
              labelStyle: TextStyle(color: AppColors.armySecondary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Branch of Service field
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _branchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.security, color: AppColors.armyPrimary),
              labelText: 'Branch of Service',
              labelStyle: TextStyle(color: AppColors.armySecondary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Division field
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _divisionController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.account_tree,
                color: AppColors.armyPrimary,
              ),
              labelText: 'Division',
              labelStyle: TextStyle(color: AppColors.armySecondary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.armyPrimary, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive breakpoints
            bool isSmallScreen = constraints.maxWidth < 400;
            bool isMediumScreen =
                constraints.maxWidth >= 400 && constraints.maxWidth < 600;
            bool isLargeScreen = constraints.maxWidth >= 600;

            // Adjust button height based on screen size
            double buttonHeight =
                isSmallScreen
                    ? 44
                    : isMediumScreen
                    ? 48
                    : 52;
            double fontSize =
                isSmallScreen
                    ? 14
                    : isMediumScreen
                    ? 16
                    : 18;
            double spacing =
                isSmallScreen
                    ? 12
                    : isMediumScreen
                    ? 16
                    : 20;

            return Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: _previousStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: SizedBox(
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.armyPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _submitForm() {
    // Collect all form data
    _formData = {
      'fullName': _nameController.text,
      'suffix': _suffixController.text,
      'serviceId': _serviceIdController.text,
      'password': _passwordController.text,
      'email': _emailController.text,
      'contactNo': _contactNoController.text,
      'streetAddress': _streetAddressController.text,
      'unit': _unitController.text,
      'branchOfService': _branchController.text,
      'division': _divisionController.text,
    };

    // TODO: Send to backend
    print('Form data: $_formData');

    // Show custom success popup
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon with Animation
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),

                // Success Title
                const Text(
                  'Account Created Successfully!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.armyPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Success Message
                const Text(
                  'Welcome to AFProTrack! Your account has been created successfully. You can now log in with your credentials.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grayText,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.armyPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.2),
                    ),
                    child: const Text(
                      'Continue to Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create your Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.armyPrimary,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          'Step ${_currentStep + 1}: Confirm Your Details',
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.grayText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 22),
        // Confirmation Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: AppColors.armyPrimary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.verified, color: AppColors.armyPrimary, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Account Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.armyPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Personal Information Section
              _buildDetailSection('Personal Information', Icons.person, [
                _buildDetailRow('Full Name', _nameController.text),
                _buildDetailRow('Suffix', _suffixController.text),
                _buildDetailRow('Email Address', _emailController.text),
              ]),
              const SizedBox(height: 16),
              // Service Information Section
              _buildDetailSection('Service Information', Icons.badge, [
                _buildDetailRow('Service ID', _serviceIdController.text),
                _buildDetailRow('Contact Number', _contactNoController.text),
                _buildDetailRow(
                  'Street Address',
                  _streetAddressController.text,
                ),
                _buildDetailRow('Unit', _unitController.text),
                _buildDetailRow('Branch of Service', _branchController.text),
                _buildDetailRow('Division', _divisionController.text),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive breakpoints
            bool isSmallScreen = constraints.maxWidth < 400;
            bool isMediumScreen =
                constraints.maxWidth >= 400 && constraints.maxWidth < 600;
            bool isLargeScreen = constraints.maxWidth >= 600;

            // Adjust button height based on screen size
            double buttonHeight =
                isSmallScreen
                    ? 44
                    : isMediumScreen
                    ? 48
                    : 52;
            double fontSize =
                isSmallScreen
                    ? 14
                    : isMediumScreen
                    ? 16
                    : 18;
            double spacing =
                isSmallScreen
                    ? 12
                    : isMediumScreen
                    ? 16
                    : 20;

            return Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: _previousStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: SizedBox(
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement final submission
                        _submitForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.armyPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    List<Widget> details,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.armyPrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.armyPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...details,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.grayText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not provided' : value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4B5320), // 0%
                    Color(0xFF121B15), // 59%
                    Color(0xFF3E503A), // 100%
                  ],
                  stops: [0.0, 0.59, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/icons/App_Logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'AFProTrack',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    '“Honor. Service. Patriotism.”',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.armyGold,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back to Login button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        IconifyIcon(
                          icon: 'lets-icons:back',
                          color: AppColors.armyPrimary,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Back to Login',
                          style: TextStyle(
                            color: AppColors.grayText,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  _buildStepContent(),
                  const SizedBox(height: 32),
                  // Show "Already have an account?" only on first step
                  if (_currentStep == 0)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const LoginView(),
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.armyPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
