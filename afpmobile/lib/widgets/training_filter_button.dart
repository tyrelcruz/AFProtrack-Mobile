import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';

class TrainingFilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TrainingFilterButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height:
            ResponsiveUtils.isMobile(context)
                ? 40
                : ResponsiveUtils.isTablet(context)
                ? 44
                : 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.filterBorder : AppColors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.isMobile(context)
                ? 20
                : ResponsiveUtils.isTablet(context)
                ? 22
                : 24,
          ),
          border:
              isSelected
                  ? null
                  : Border.all(
                    color: const Color(0xFFC4C4C4).withOpacity(0.4),
                    width: ResponsiveUtils.isMobile(context) ? 1.5 : 2.0,
                  ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.filterBorder,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveUtils.getResponsiveFontSize(
                context,
                mobile: 12.0,
                tablet: 13.0,
                desktop: 14.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
