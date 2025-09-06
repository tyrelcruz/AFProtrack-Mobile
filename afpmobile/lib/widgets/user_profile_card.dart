import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';
import 'skeleton_loading.dart';

class UserProfileCard extends StatelessWidget {
  final String name;
  final String rank;
  final String unit;
  final String serviceId;
  final int trainingProgress;
  final int readinessLevel;
  final Color cardColor;
  final String? profilePhotoUrl; // Add profile photo URL parameter
  final bool isLoading; // Add loading parameter

  const UserProfileCard({
    Key? key,
    required this.name,
    required this.rank,
    required this.unit,
    required this.serviceId,
    required this.trainingProgress,
    required this.readinessLevel,
    this.cardColor = Colors.white,
    this.profilePhotoUrl, // Add to constructor
    this.isLoading = false, // Add to constructor
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

    return Column(
      children: [
        // User Information Header
        Card(
          margin: EdgeInsets.symmetric(
            vertical: 12,
            horizontal:
                ResponsiveUtils.isMobile(context) ? width * 0.04 : width * 0.02,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          color: cardColor,
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Row(
              children: [
                // Profile Picture
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child:
                      profilePhotoUrl != null
                          ? ClipOval(
                            child: Image.network(
                              profilePhotoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.grey[600],
                                );
                              },
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.armyPrimary,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                          : Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey[600],
                          ),
                ),
                SizedBox(width: 16),
                // User Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: nameFontSize,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        rank,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: rankFontSize,
                          color: AppColors.armyPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: serviceIdFontSize,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        serviceId,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[500],
                          fontSize: serviceIdFontSize - 1,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Progress Tracking Section
        Card(
          margin: EdgeInsets.symmetric(
            horizontal:
                ResponsiveUtils.isMobile(context) ? width * 0.04 : width * 0.02,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          color: cardColor,
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Training Progress
                isLoading
                    ? const ProgressBarSkeleton()
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.school,
                              color: Colors.green[600],
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Training Progress',
                              style: TextStyle(
                                fontSize: labelFontSize,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '$trainingProgress%',
                              style: TextStyle(
                                fontSize: labelFontSize,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: trainingProgress / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                SizedBox(height: 16),

                // Combat Readiness
                isLoading
                    ? const ProgressBarSkeleton()
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.fitness_center,
                              color: Colors.green[600],
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Combat Readiness',
                              style: TextStyle(
                                fontSize: labelFontSize,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '$readinessLevel%',
                              style: TextStyle(
                                fontSize: labelFontSize,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: readinessLevel / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
