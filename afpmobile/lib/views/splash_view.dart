import 'package:flutter/material.dart';
import 'login_view.dart';
import 'main_navigation_view.dart';
import 'dart:async';

// Toggle this flag to bypass login temporarily without removing implementation
const bool kBypassLogin = false;

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      final Widget next =
          kBypassLogin ? const MainNavigationView() : const LoginView();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => next));
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double logoSize = mediaQuery.size.width * 0.28;
    final double titleFont = mediaQuery.size.width * 0.08;
    final double subtitleFont = mediaQuery.size.width * 0.038;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B5320), Color(0xFF121B15), Color(0xFF3E503A)],
            stops: [0.0, 0.59, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/App_Logo.png',
                width: logoSize.clamp(80, 160),
                height: logoSize.clamp(80, 160),
                fit: BoxFit.contain,
              ),
              SizedBox(height: mediaQuery.size.height * 0.03),
              Text(
                'AFProTrack',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleFont.clamp(24, 40),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Text(
                'Training System App for Armed Forces of the Philippines',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: subtitleFont.clamp(12, 20),
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.015),
              Text(
                '“Honor. Service. Patriotism.”',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: (subtitleFont * 0.95).clamp(11, 18),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
