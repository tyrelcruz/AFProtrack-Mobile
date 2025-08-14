import 'package:flutter/material.dart';
import 'package:iconify_design/iconify_design.dart';
import '../utils/app_colors.dart';
import '../services/api_service.dart';

import 'login_view.dart';

// Data structure for military branches and their divisions/units
class MilitaryData {
  static const Map<String, Map<String, List<String>>> branches = {
    'Philippine Army (PA)': {
      'Infantry Divisions': [
        '1st Infantry Division (1ID)',
        '2nd Infantry Division (2ID)',
        '3rd Infantry Division (3ID)',
        '4th Infantry Division (4ID)',
        '5th Infantry Division (5ID)',
        '6th Infantry Division (6ID)',
        '7th Infantry Division (7ID)',
        '8th Infantry Division (8ID)',
        '9th Infantry Division (9ID)',
        '10th Infantry Division (10ID)',
        '11th Infantry Division (11ID)',
      ],
      'Specialized / Support Units': [
        'Armor "Pambato" Division (Armor Div)',
        'Special Forces Regiment (Airborne) (SFR-A)',
        'Scout Ranger Regiment (SRR)',
        'Army Aviation Regiment (AAR)',
        'Civil-Military Operations Regiment (CMOR)',
      ],
    },
    'Philippine Navy (PN)': {
      'Naval Operating Forces': [
        'Naval Forces Northern Luzon (NFNL)',
        'Naval Forces Southern Luzon (NFSL)',
        'Naval Forces Western Mindanao (NFWM)',
        'Naval Forces Eastern Mindanao (NFEM)',
        'Naval Forces West (NFW)',
      ],
      'Fleet Units': [
        'Offshore Combat Force (OCF)',
        'Littoral Combat Force (LCF)',
        'Sealift Amphibious Force (SAF)',
        'Naval Air Wing (NAW)',
      ],
      'Naval Special Operations': [
        'Naval Special Operations Command (NAVSOCOM)',
      ],
      'Philippine Marine Corps': ['Marine Special Operations Group (MARSOG)'],
    },
    'Philippine Air Force (PAF)': {
      'Air Wings': [
        '5th Fighter Wing (5FW)',
        '15th Strike Wing (15SW)',
        '205th Tactical Helicopter Wing (205THW)',
        '220th Airlift Wing (220AW)',
      ],
      'Operational Commands': [
        'Air Defense Command (ADC)',
        'Air Mobility Command (AMC)',
        'Tactical Operations Wing - Northern Luzon (TOWNL)',
        'Tactical Operations Wing - Southern Luzon (TOWSL)',
        'Tactical Operations Wing - Central (TOWC)',
        'Tactical Operations Wing - Western Mindanao (TOWWM)',
        'Tactical Operations Wing - Eastern Mindanao (TOWEM)',
      ],
      'Support / Training': [
        'Air Education, Training, and Doctrine Command (AETDC)',
        'Air Logistics Command (ALC)',
      ],
    },
  };

  static List<String> getBranches() {
    return branches.keys.toList();
  }

  static List<String> getDivisions(String branch) {
    if (branches.containsKey(branch)) {
      return branches[branch]!.keys.toList();
    }
    return [];
  }

  static List<String> getUnits(String branch, String division) {
    if (branches.containsKey(branch) &&
        branches[branch]!.containsKey(division)) {
      return branches[branch]![division]!;
    }
    return [];
  }
}

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> with TickerProviderStateMixin {
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Animation controllers
  late AnimationController _stepTransitionController;
  late AnimationController _formElementsController;
  late AnimationController _headerController;

  // Animations
  late Animation<double> _stepTransitionAnimation;
  late Animation<double> _formElementsAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _headerAnimation;

  // Form controllers for Step 1
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _suffixController = TextEditingController();
  final TextEditingController _serviceIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  // Form controllers for Step 2
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _streetAddressController =
      TextEditingController();

  // Dropdown values
  String? _selectedBranch;
  String? _selectedDivision;
  String? _selectedUnit;

  // Store form data
  Map<String, dynamic> _formData = {};

  // Loading state for form submission
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _stepTransitionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _formElementsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize animations
    _stepTransitionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _stepTransitionController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _formElementsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _formElementsController,
        curve: Curves.easeOutCubic,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _formElementsController,
        curve: Curves.easeOutCubic,
      ),
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutBack),
    );

    // Start initial animations
    _startInitialAnimations();
  }

  void _startInitialAnimations() async {
    // Start step transition animation immediately
    _stepTransitionController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _headerController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _formElementsController.forward();
  }

  @override
  void dispose() {
    _stepTransitionController.dispose();
    _formElementsController.dispose();
    _headerController.dispose();
    _nameController.dispose();
    _suffixController.dispose();
    _serviceIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdayController.dispose();
    _emailController.dispose();
    _contactNoController.dispose();
    _streetAddressController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (_currentStep < _totalSteps - 1) {
      // Animate out current step
      await _stepTransitionController.reverse();

      setState(() {
        _currentStep++;
      });

      // Animate in new step
      _stepTransitionController.forward();
      _formElementsController.reset();
      _formElementsController.forward();
    }
  }

  void _previousStep() async {
    if (_currentStep > 0) {
      // Animate out current step
      await _stepTransitionController.reverse();

      setState(() {
        _currentStep--;
      });

      // Animate in new step
      _stepTransitionController.forward();
      _formElementsController.reset();
      _formElementsController.forward();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
      firstDate: DateTime.now().subtract(
        const Duration(days: 36500),
      ), // 100 years ago
      lastDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.armyPrimary,
              onPrimary: Colors.white,
              onSurface: AppColors.armyPrimary,
              surface: Colors.white,
              onSecondary: Colors.white,
              secondary: AppColors.armyPrimary.withOpacity(0.8),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 20,
              backgroundColor: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.armyPrimary,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: child!,
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Format date in a more modern way
        final months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        _birthdayController.text =
            "${months[picked.month - 1]} ${picked.day}, ${picked.year}";
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
        // Title with animation
        FadeTransition(
          opacity: _formElementsAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _formElementsController,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: const Text(
              'Create your Account',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.armyPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: _formElementsAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -0.2),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _formElementsController,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: Text(
              'Step ${_currentStep + 1}: Basic Account Information',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.grayText,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        // Name and Suffix fields with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
          child: Row(
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
                      labelStyle: TextStyle(color: AppColors.armyPrimary),
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
                      labelText: 'Suffix',
                      hintText: 'Jr., Sr., III, etc.',
                      labelStyle: TextStyle(color: AppColors.armyPrimary),
                      hintStyle: TextStyle(
                        color: AppColors.armyPrimary.withOpacity(0.6),
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
        ),
        const SizedBox(height: 16),
        // Birthday field with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
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
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.armyPrimary, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.armyPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Date of Birth',
                              style: TextStyle(
                                color: AppColors.armyPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _birthdayController.text.isEmpty
                                  ? 'Select your birthday'
                                  : _birthdayController.text,
                              style: TextStyle(
                                color:
                                    _birthdayController.text.isEmpty
                                        ? AppColors.armyPrimary.withOpacity(0.6)
                                        : AppColors.armyPrimary,
                                fontSize: 14,
                                fontWeight:
                                    _birthdayController.text.isEmpty
                                        ? FontWeight.normal
                                        : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.armyPrimary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Email field with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
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
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: AppColors.armyPrimary),
                labelText: 'Email Address',
                labelStyle: TextStyle(color: AppColors.armyPrimary),
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
        const SizedBox(height: 16),
        // Password field with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
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
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: AppColors.armyPrimary),
                labelText: 'Password',
                labelStyle: TextStyle(color: AppColors.armyPrimary),
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
        const SizedBox(height: 16),
        // Confirm Password field with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
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
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColors.armyPrimary,
                ),
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: AppColors.armyPrimary),
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
        const SizedBox(height: 24),
        // Next button with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
          child: LayoutBuilder(
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
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
          child: const Text(
            'Create your Account',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.armyPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        FadeTransition(
          opacity: _formElementsAnimation,
          child: Text(
            'Step ${_currentStep + 1}: Service & Contact Information',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grayText,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 22),
        // Service ID field with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
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
              controller: _serviceIdController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.badge, color: AppColors.armyPrimary),
                labelText: 'Service ID',
                labelStyle: TextStyle(color: AppColors.armyPrimary),
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
        const SizedBox(height: 16),
        // Contact Number field with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
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
              controller: _contactNoController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone, color: AppColors.armyPrimary),
                labelText: 'Contact Number',
                labelStyle: TextStyle(color: AppColors.armyPrimary),
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
        const SizedBox(height: 16),
        // Street Address field with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
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
              controller: _streetAddressController,
              maxLines: 2,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.location_on,
                  color: AppColors.armyPrimary,
                ),
                labelText: 'Street Address',
                labelStyle: TextStyle(color: AppColors.armyPrimary),
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
        const SizedBox(height: 16),
        // Branch of Service dropdown with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
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
            child: DropdownButtonFormField<String>(
              key: const ValueKey('branch_dropdown'),
              value: _selectedBranch,
              hint: const Text('Select Branch'),
              isExpanded: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.security, color: AppColors.armyPrimary),
                labelText: 'Branch of Service',
                labelStyle: TextStyle(color: AppColors.armyPrimary),
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
                // Add right padding to prevent overflow with dropdown icon
                contentPadding: EdgeInsets.only(
                  left: 16,
                  right: 40, // Extra space for dropdown icon
                  top: 16,
                  bottom: 16,
                ),
              ),
              items:
                  MilitaryData.getBranches().map((String branch) {
                    return DropdownMenuItem<String>(
                      value: branch,
                      child: Text(
                        branch,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBranch = newValue;
                  _selectedDivision =
                      null; // Reset division when branch changes
                  _selectedUnit = null; // Reset unit when branch changes
                });
              },
              // Customize dropdown button icon
              icon: Icon(Icons.arrow_drop_down, color: AppColors.armyPrimary),
              iconSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Division dropdown with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
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
            child: DropdownButtonFormField<String>(
              key: const ValueKey('division_dropdown'),
              value: _selectedDivision,
              hint: const Text('Select Division'),
              isExpanded: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_tree,
                  color: AppColors.armyPrimary,
                ),
                labelText: 'Division',
                labelStyle: TextStyle(color: AppColors.armyPrimary),
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
                // Add right padding to prevent overflow with dropdown icon
                contentPadding: EdgeInsets.only(
                  left: 16,
                  right: 40, // Extra space for dropdown icon
                  top: 16,
                  bottom: 16,
                ),
              ),
              items:
                  _selectedBranch != null &&
                          MilitaryData.getDivisions(_selectedBranch!).isNotEmpty
                      ? MilitaryData.getDivisions(_selectedBranch!).map((
                        String division,
                      ) {
                        return DropdownMenuItem<String>(
                          value: division,
                          child: Text(
                            division,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList()
                      : [],
              onChanged:
                  _selectedBranch != null &&
                          MilitaryData.getDivisions(_selectedBranch!).isNotEmpty
                      ? (String? newValue) {
                        setState(() {
                          _selectedDivision = newValue;
                          _selectedUnit =
                              null; // Reset unit when division changes
                        });
                      }
                      : null,
              // Customize dropdown button icon
              icon: Icon(Icons.arrow_drop_down, color: AppColors.armyPrimary),
              iconSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Unit dropdown with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
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
            child: DropdownButtonFormField<String>(
              key: const ValueKey('unit_dropdown'),
              value: _selectedUnit,
              hint: const Text('Select Unit'),
              isExpanded: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.group, color: AppColors.armyPrimary),
                labelText: 'Unit',
                labelStyle: TextStyle(color: AppColors.armyPrimary),
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
                // Add right padding to prevent overflow with dropdown icon
                contentPadding: EdgeInsets.only(
                  left: 16,
                  right: 40, // Extra space for dropdown icon
                  top: 16,
                  bottom: 16,
                ),
              ),
              items:
                  (_selectedBranch != null &&
                          _selectedDivision != null &&
                          MilitaryData.getUnits(
                            _selectedBranch!,
                            _selectedDivision!,
                          ).isNotEmpty)
                      ? MilitaryData.getUnits(
                        _selectedBranch!,
                        _selectedDivision!,
                      ).map((String unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(
                            unit,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList()
                      : [],
              onChanged:
                  (_selectedBranch != null &&
                          _selectedDivision != null &&
                          MilitaryData.getUnits(
                            _selectedBranch!,
                            _selectedDivision!,
                          ).isNotEmpty)
                      ? (String? newValue) {
                        setState(() {
                          _selectedUnit = newValue;
                        });
                      }
                      : null,
              // Customize dropdown button icon
              icon: Icon(Icons.arrow_drop_down, color: AppColors.armyPrimary),
              iconSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Buttons with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
          child: LayoutBuilder(
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
        ),
      ],
    );
  }

  void _submitForm() async {
    // Set loading state
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Parse the full name into first and last name
      final fullName = _nameController.text.trim();
      if (fullName.isEmpty) {
        throw Exception('Full name is required');
      }

      final nameParts = fullName.split(' ');
      String firstName, lastName;

      if (nameParts.length == 1) {
        // Only one name provided, use it as first name
        firstName = nameParts[0];
        lastName = '';
      } else if (nameParts.length == 2) {
        // Two names provided
        firstName = nameParts[0];
        lastName = nameParts[1];
      } else {
        // More than two names, first is first name, rest is last name
        firstName = nameParts[0];
        lastName = nameParts.sublist(1).join(' ');
      }

      // Parse birthday string to Date
      DateTime? dateOfBirth;
      if (_birthdayController.text.isNotEmpty) {
        final parts = _birthdayController.text.split('/');
        if (parts.length == 3) {
          final month = int.tryParse(parts[0]) ?? 1;
          final day = int.tryParse(parts[1]) ?? 1;
          final year = int.tryParse(parts[2]) ?? 1990;
          dateOfBirth = DateTime(year, month, day);
        }
      }

      // Format data according to backend model
      final userData = {
        'firstName': firstName,
        'lastName': lastName,
        'suffix': _suffixController.text.trim(),
        'serviceId': _serviceIdController.text.trim().toUpperCase(),
        'email': _emailController.text.trim().toLowerCase(),
        'unit': _selectedUnit ?? '',
        'branchOfService': _selectedBranch ?? '',
        'division': _selectedDivision ?? '',
        'address': _streetAddressController.text.trim(),
        'contactNumber': _contactNoController.text.trim(),
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'password': _passwordController.text,
        'accountType': 'mobile', // Since this is mobile app
        'role': 'personnel', // Default role for new signups
      };

      // Validate required fields
      if (firstName.isEmpty) {
        throw Exception('First name is required');
      }
      if (lastName.isEmpty) {
        throw Exception('Last name is required');
      }
      if (_serviceIdController.text.isEmpty) {
        throw Exception('Service ID is required');
      }
      if (_emailController.text.isEmpty) {
        throw Exception('Email is required');
      }
      if (_passwordController.text.length < 8) {
        throw Exception('Password must be at least 8 characters long');
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        throw Exception('Passwords do not match');
      }
      if (dateOfBirth == null) {
        throw Exception('Date of birth is required');
      }

      // Make API call to create pending account
      final result = await ApiService.createPendingAccount(userData);

      if (result['success']) {
        // Show success dialog
        _showSuccessDialog();
      } else {
        // Show error dialog
        _showErrorDialog(result['message'] ?? 'Failed to create account');
      }
    } catch (e) {
      // Show error dialog
      _showErrorDialog(e.toString());
    } finally {
      // Reset loading state
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showErrorDialog(String errorMessage) {
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
                // Error Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.error_outline, color: Colors.red, size: 50),
                ),
                const SizedBox(height: 20),

                // Error Title
                const Text(
                  'Account Creation Failed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Error Message
                Text(
                  errorMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grayText,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Try Again Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.2),
                    ),
                    child: const Text(
                      'Try Again',
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
                  'Welcome to AFProTrack! Your account has been created successfully and is pending approval. You will be notified once your account is approved.',
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
        // Title with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
          child: const Text(
            'Create your Account',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.armyPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        FadeTransition(
          opacity: _formElementsAnimation,
          child: Text(
            'Step ${_currentStep + 1}: Confirm Your Details',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grayText,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 22),
        // Confirmation Card with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
          child: Container(
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
                    Icon(
                      Icons.verified,
                      color: AppColors.armyPrimary,
                      size: 24,
                    ),
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
                  _buildDetailRow('Date of Birth', _birthdayController.text),
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
                  _buildDetailRow('Unit', _selectedUnit ?? 'Not selected'),
                  _buildDetailRow(
                    'Branch of Service',
                    _selectedBranch ?? 'Not selected',
                  ),
                  _buildDetailRow(
                    'Division',
                    _selectedDivision ?? 'Not selected',
                  ),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Buttons with fade animation
        FadeTransition(
          opacity: _formElementsAnimation,
          child: LayoutBuilder(
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
                        onPressed:
                            _isSubmitting
                                ? null
                                : () {
                                  // TODO: Implement final submission
                                  _submitForm();
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isSubmitting
                                  ? AppColors.armyPrimary.withOpacity(0.7)
                                  : AppColors.armyPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: _isSubmitting ? 2 : 6,
                          shadowColor: Colors.black.withOpacity(0.2),
                        ),
                        child:
                            _isSubmitting
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: fontSize * 0.8,
                                      height: fontSize * 0.8,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: fontSize * 0.5),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Creating...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontSize * 0.9,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : FittedBox(
                                  fit: BoxFit.scaleDown,
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
                  ),
                ],
              );
            },
          ),
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
      body: Column(
        children: [
          // Fixed Header with animation
          FadeTransition(
            opacity: _headerAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -0.5),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _headerController,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: Container(
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
                    // Logo with scale animation
                    ScaleTransition(
                      scale: _headerAnimation,
                      child: Center(
                        child: Image.asset(
                          'assets/icons/App_Logo.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
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
                      '"Honor. Service. Patriotism."',
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
            ),
          ),
          // Scrollable content below the gradient
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Back to Login button with fade animation
                    FadeTransition(
                      opacity: _formElementsAnimation,
                      child: GestureDetector(
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
                    ),
                    const SizedBox(height: 26),
                    _buildStepContent(),
                    const SizedBox(height: 32),
                    // Show "Already have an account?" only on first step
                    if (_currentStep == 0)
                      FadeTransition(
                        opacity: _formElementsAnimation,
                        child: Center(
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
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
