import 'package:flutter/material.dart';
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
                elevation: 1,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: labelFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: isMobile ? 2 : 4),
                            Text(
                              item.value.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: valueFontSize,
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
