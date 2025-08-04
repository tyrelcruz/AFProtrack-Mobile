import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

import 'signup_view.dart';
import 'main_navigation_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  bool _rememberMe = false;
  bool _isLoading = false;

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
    super.dispose();
  }

  // Simulated login function with animation
  Future<void> _handleLogin() async {
    if (_isLoading) return; // Prevent multiple calls

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));

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
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      // Handle error if needed
      print('Login error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _animateExit() async {
    // Reverse animations in order
    await _buttonController.reverse();
    await _formController.reverse();
    await _titleController.reverse();
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
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.badge,
                              color: AppColors.armyPrimary,
                            ),
                            labelText: 'Service ID',
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
                            onPressed: () {},
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
