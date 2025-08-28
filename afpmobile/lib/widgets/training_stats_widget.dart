import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/responsive_utils.dart';

class StatItem {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class TrainingStatsWidget extends StatefulWidget {
  final Color cardColor;

  const TrainingStatsWidget({Key? key, this.cardColor = Colors.white})
    : super(key: key);

  @override
  State<TrainingStatsWidget> createState() => _TrainingStatsWidgetState();
}

class _TrainingStatsWidgetState extends State<TrainingStatsWidget> {
  bool _isLoading = true;
  String? _error;
  Map<String, int> _stats = {
    'completed': 0,
    'ongoing': 0,
    'scheduled': 0,
    'certificates': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadTrainingStats();
  }

  Future<void> _loadTrainingStats() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await ApiService.getTrainingStatistics();

      if (response['success']) {
        setState(() {
          _stats = Map<String, int>.from(response['data']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response['message'] ?? 'Failed to load statistics';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  List<StatItem> _buildStatsItems() {
    return [
      StatItem(
        icon: Icons.check_circle,
        label: 'Completed',
        value: _stats['completed'] ?? 0,
        color: Colors.green,
      ),
      StatItem(
        icon: Icons.autorenew,
        label: 'Ongoing',
        value: _stats['ongoing'] ?? 0,
        color: Colors.blue,
      ),
      StatItem(
        icon: Icons.event,
        label: 'Scheduled',
        value: _stats['scheduled'] ?? 0,
        color: Colors.orange,
      ),
      StatItem(
        icon: Icons.verified,
        label: 'Certificates',
        value: _stats['certificates'] ?? 0,
        color: Colors.purple,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Card(
          color: widget.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.grey[600]!,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Loading statistics...',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Card(
          color: widget.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red[600], size: 24),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: TextStyle(color: Colors.red[600], fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _loadTrainingStats,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return StatsGrid(items: _buildStatsItems(), cardColor: widget.cardColor);
  }
}

class StatsGrid extends StatelessWidget {
  final List<StatItem> items;
  final Color cardColor;

  const StatsGrid({
    Key? key,
    required this.items,
    this.cardColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Use responsive utils for better breakpoint handling
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    // Adjust aspect ratio based on screen size
    final aspectRatio = isMobile ? 1.8 : (isTablet ? 2.2 : 2.5);

    // Adjust font sizes based on screen size
    final labelFontSize = ResponsiveUtils.getResponsiveFontSize(
      context,
      mobile: 11.0,
      tablet: 13.0,
      desktop: 14.0,
    );
    final valueFontSize = ResponsiveUtils.getResponsiveFontSize(
      context,
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
    final iconSize = isMobile ? 20.0 : (isTablet ? 24.0 : 28.0);

    // Adjust padding based on screen size
    final horizontalPadding = ResponsiveUtils.getResponsivePadding(
      context,
      mobile: 6.0,
      tablet: 8.0,
      desktop: 10.0,
    );
    final verticalPadding = ResponsiveUtils.getResponsivePadding(
      context,
      mobile: 10.0,
      tablet: 12.0,
      desktop: 14.0,
    );
    final iconPadding = isMobile ? 5.0 : (isTablet ? 6.0 : 7.0);
    final spacing = isMobile ? 8.0 : (isTablet ? 10.0 : 12.0);
    final iconLeftInset = isMobile ? 6.0 : (isTablet ? 8.0 : 10.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: aspectRatio,
        children:
            items.map((item) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: cardColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: iconLeftInset),
                      Container(
                        decoration: BoxDecoration(
                          color: item.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(iconPadding),
                        child: Icon(
                          item.icon,
                          color: item.color,
                          size: iconSize,
                        ),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.value.toString(),
                              style: TextStyle(
                                fontSize: valueFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: labelFontSize,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
