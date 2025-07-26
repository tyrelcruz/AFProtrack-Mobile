import 'package:flutter/material.dart';

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
    final height = MediaQuery.of(context).size.height;

    // Calculate responsive values
    final isSmallScreen = width < 360;
    final isMediumScreen = width >= 360 && width < 600;

    // Adjust aspect ratio based on screen size
    final aspectRatio = isSmallScreen ? 1.8 : (isMediumScreen ? 2.0 : 2.2);

    // Adjust font sizes based on screen size
    final labelFontSize = isSmallScreen ? 11.0 : (isMediumScreen ? 12.0 : 13.0);
    final valueFontSize = isSmallScreen ? 16.0 : (isMediumScreen ? 17.0 : 18.0);
    final iconSize = isSmallScreen ? 20.0 : (isMediumScreen ? 22.0 : 24.0);

    // Adjust padding based on screen size
    final horizontalPadding =
        isSmallScreen ? 6.0 : (isMediumScreen ? 7.0 : 8.0);
    final verticalPadding =
        isSmallScreen ? 10.0 : (isMediumScreen ? 11.0 : 12.0);
    final iconPadding = isSmallScreen ? 5.0 : (isMediumScreen ? 5.5 : 6.0);
    final spacing = isSmallScreen ? 8.0 : (isMediumScreen ? 9.0 : 10.0);

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
                            SizedBox(height: isSmallScreen ? 2 : 4),
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
