import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';

class UserProfileCard extends StatelessWidget {
  final String name;
  final String rank;
  final String unit;
  final String serviceId;
  final int trainingProgress;
  final int readinessLevel;
  final Color cardColor;

  const UserProfileCard({
    Key? key,
    required this.name,
    required this.rank,
    required this.unit,
    required this.serviceId,
    required this.trainingProgress,
    required this.readinessLevel,
    this.cardColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Responsive font sizes
    final nameFontSize = ResponsiveUtils.getResponsiveFontSize(
      context,
      mobile: 18.0,
      tablet: 20.0,
      desktop: 22.0,
    );
    final rankFontSize = ResponsiveUtils.getResponsiveFontSize(
      context,
      mobile: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );
    final serviceIdFontSize = ResponsiveUtils.getResponsiveFontSize(
      context,
      mobile: 13.0,
      tablet: 14.0,
      desktop: 15.0,
    );
    final progressFontSize = ResponsiveUtils.getResponsiveFontSize(
      context,
      mobile: 20.0,
      tablet: 22.0,
      desktop: 24.0,
    );
    final labelFontSize = ResponsiveUtils.getResponsiveFontSize(
      context,
      mobile: 12.0,
      tablet: 13.0,
      desktop: 14.0,
    );

    // Responsive padding
    final cardPadding = ResponsiveUtils.getResponsivePadding(
      context,
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );

    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 12,
        horizontal:
            ResponsiveUtils.isMobile(context) ? width * 0.04 : width * 0.02,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: nameFontSize,
              ),
            ),
            SizedBox(height: 2),
            Text(
              '$rank - $unit',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: rankFontSize,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Service ID: $serviceId',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
                fontSize: serviceIdFontSize,
              ),
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '$trainingProgress%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: progressFontSize,
                      ),
                    ),
                    Text(
                      'Training Progress',
                      style: TextStyle(fontSize: labelFontSize),
                    ),
                  ],
                ),
                Container(width: 1, height: 32, color: Colors.grey[300]),
                Column(
                  children: [
                    Text(
                      '$readinessLevel%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: progressFontSize,
                      ),
                    ),
                    Text(
                      'Readiness Level',
                      style: TextStyle(fontSize: labelFontSize),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
