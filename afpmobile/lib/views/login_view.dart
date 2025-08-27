import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_colors.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

import 'signup_view.dart';
import 'main_navigation_view.dart';
import '../widgets/forgot_password_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  bool _rememberMe = false;
  bool _isLoading = false;

  // Text controllers for login form
  final TextEditingController _emailOrServiceIdController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Static flag to track if this is the initial app launch
  static bool _isInitialLaunch = true;

  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _formController;
  late AnimationController _buttonController;

  // Animations
  late Animation<double> _logoAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _formController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Initialize animations
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
    );

    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
    );

    // Only start animations if this is the initial launch
    if (_isInitialLaunch) {
      _startAnimations();
      // Mark that we've already done the initial launch
      _isInitialLaunch = false;
    } else {
      // If not initial launch, immediately set all animations to completed state
      _logoController.value = 1.0;
      _titleController.value = 1.0;
      _formController.value = 1.0;
      _buttonController.value = 1.0;
    }

    // Load remembered credentials if available
    _loadRememberedCredentials();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _titleController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _formController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _buttonController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _formController.dispose();
    _buttonController.dispose();
    _emailOrServiceIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login function with backend integration
  Future<void> _handleLogin() async {
    if (_isLoading) return; // Prevent multiple calls

    // Validate inputs
    if (_emailOrServiceIdController.text.trim().isEmpty) {
      _showErrorDialog('Email or Service ID is required');
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      _showErrorDialog('Password is required');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call backend login API
      final result = await ApiService.login(
        _emailOrServiceIdController.text.trim(),
        _passwordController.text.trim(),
      );

      if (result['success']) {
        // Save authentication data
        final userData = result['data'];
        // Enforce role-based access: only allow 'trainee'
        final dynamic user = userData != null ? userData['user'] : null;
        final dynamic rawRole =
            user != null ? (user['role'] ?? user['accountType']) : null;
        String? resolvedRole;
        if (rawRole is String) {
          resolvedRole = rawRole.toLowerCase();
        } else if (rawRole is List) {
          // If backend returns roles array, find a matching role
          try {
            resolvedRole = rawRole
                .map((e) => e.toString().toLowerCase())
                .firstWhere(
                  (r) =>
                      r == 'trainee' || r == 'admin' || r == 'training_staff',
                  orElse: () => '',
                );
          } catch (_) {
            resolvedRole = null;
          }
        }

        if (resolvedRole == null ||
            resolvedRole.isEmpty ||
            resolvedRole != 'trainee') {
          _showErrorDialog('Only trainee accounts can log in on this app.');
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          return;
        }
        if (userData != null && userData['token'] != null) {
          await TokenService.saveAuthData(
            token: userData['token'],
            refreshToken: userData['refreshToken'],
            userId: userData['user']?['_id'] ?? userData['user']?['id'],
            userData: userData['user'],
          );
        }

        // Handle remember password preference after successful login
        if (_rememberMe) {
          await _saveRememberedCredentials(
            _emailOrServiceIdController.text.trim(),
            _passwordController.text.trim(),
          );
        } else {
          await _clearRememberedCredentials();
        }

        // Login successful
        // Animate exit before navigation
        await _animateExit();

        // Navigate to main screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) =>
                      const MainNavigationView(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, -1.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 200),
            ),
          );
        }
      } else {
        // Login failed
        _showErrorDialog(result['message'] ?? 'Login failed');
      }
    } catch (e) {
      // Handle error
      _showErrorDialog('Network error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Load saved credentials from SharedPreferences
  Future<void> _loadRememberedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRemember = prefs.getBool('remember_me') ?? false;
      if (savedRemember) {
        final savedUsername = prefs.getString('remember_username') ?? '';
        final savedPassword = prefs.getString('remember_password') ?? '';
        setState(() {
          _rememberMe = true;
          _emailOrServiceIdController.text = savedUsername;
          _passwordController.text = savedPassword;
        });
      }
    } catch (e) {
      // Ignore errors silently for UX
    }
  }

  // Save credentials based on user preference
  Future<void> _saveRememberedCredentials(
    String username,
    String password,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', true);
      await prefs.setString('remember_username', username);
      await prefs.setString('remember_password', password);
    } catch (e) {
      // Ignore errors silently for UX
    }
  }

  // Clear saved credentials
  Future<void> _clearRememberedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('remember_me');
      await prefs.remove('remember_username');
      await prefs.remove('remember_password');
    } catch (e) {
      // Ignore errors silently for UX
    }
  }

  void _showErrorDialog(String message) {
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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error Icon with background
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),

                // Error Title
                const Text(
                  'Login Failed',
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
                  message,
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
                      Navigator.of(context).pop();
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

  Future<void> _animateExit() async {
    // Reverse animations in order with faster duration
    await _buttonController.reverse();
    await Future.delayed(const Duration(milliseconds: 50));
    await _formController.reverse();
    await Future.delayed(const Duration(milliseconds: 50));
    await _titleController.reverse();
    await Future.delayed(const Duration(milliseconds: 50));
    await _logoController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final isSmallScreen = width < 400;
    final horizontalPadding = width * 0.08;
    final logoSize = width * 0.25;
    final titleFontSize = isSmallScreen ? 24.0 : 32.0;
    final subtitleFontSize = isSmallScreen ? 12.0 : 15.0;
    final quoteFontSize = isSmallScreen ? 11.0 : 13.0;
    final loginTitleFontSize = isSmallScreen ? 16.0 : 20.0;
    final buttonFontSize = isSmallScreen ? 15.0 : 18.0;
    final partnerFontSize = isSmallScreen ? 11.0 : 13.0;
    final copyrightFontSize = isSmallScreen ? 10.0 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section with logo and title animations
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: height * 0.08,
                bottom: height * 0.04,
              ),
              decoration: BoxDecoration(
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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Logo with animation
                  ScaleTransition(
                    scale: _logoAnimation,
                    child: Container(
                      child: Center(
                        child: Image.asset(
                          'assets/icons/App_Logo.png',
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  // Title with animation
                  FadeTransition(
                    opacity: _titleAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, -0.5),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _titleController,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: Text(
                        'AFProTrack',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  FadeTransition(
                    opacity: _titleAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, -0.3),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _titleController,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: Text(
                        'Training System App for Armed Forces of the Philippines',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: subtitleFontSize,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  FadeTransition(
                    opacity: _titleAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, -0.3),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _titleController,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: Text(
                        '"Honor. Service. Patriotism."',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: quoteFontSize,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.045),
            // Form section with slide animation
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _formAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personnel Login',
                        style: TextStyle(
                          fontSize: loginTitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: AppColors.armyPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: height * 0.03),
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
                          controller: _emailOrServiceIdController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppColors.armyPrimary,
                            ),
                            labelText: 'Email or Service ID',
                            hintText: 'Enter your email or service ID',
                            labelStyle: TextStyle(
                              color: AppColors.armySecondary,
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
                      SizedBox(height: height * 0.02),
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
                            prefixIcon: Icon(
                              Icons.lock,
                              color: AppColors.armyPrimary,
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: AppColors.armySecondary,
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
                      SizedBox(height: height * 0.01),
                      Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: AppColors.armyPrimary,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rememberMe = !_rememberMe;
                                  });
                                },
                                child: Text(
                                  'Remember Password',
                                  style: TextStyle(
                                    color: AppColors.armyPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: isSmallScreen ? 12 : 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => const ForgotPasswordDialog(),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.armyPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.03),
                      // Login button with animation
                      ScaleTransition(
                        scale: _buttonAnimation,
                        child: FadeTransition(
                          opacity: _buttonAnimation,
                          child: SizedBox(
                            width: double.infinity,
                            height: height * 0.065,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.armyPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 6,
                                shadowColor: Colors.black.withOpacity(0.2),
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: buttonFontSize,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      FadeTransition(
                        opacity: _buttonAnimation,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: isSmallScreen ? 12 : 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const SignupView(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: AppColors.armyPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallScreen ? 12 : 14,
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
      ),
    );
  }
}
