import 'package:flutter/material.dart';
import 'home_view.dart';
import 'schedule_view.dart';
import 'training_view.dart';
import 'certificate_view.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_bar_widget.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({Key? key}) : super(key: key);

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  // Animation controllers for dashboard entrance
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Widget> _pages = [
    const HomeView(),
    const ScheduleView(),
    const TrainingView(),
    const CertificateView(),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize entrance animations
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    // Start entrance animation
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: IndexedStack(index: _currentIndex, children: _pages),
        ),
      ),
      bottomNavigationBar: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _entranceController,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

// Placeholder view for Training and Certificates tabs
class PlaceholderView extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderView({Key? key, required this.title, required this.icon})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBarWidget(title: title),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
