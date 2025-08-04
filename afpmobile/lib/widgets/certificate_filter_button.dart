import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_utils.dart';

class CertificateFilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CertificateFilterButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive dimensions
    double buttonHeight;
    double fontSize;
    double horizontalPadding;

    if (screenWidth < 360) {
      // Small phones
      buttonHeight = 32;
      fontSize = 11;
      horizontalPadding = 8;
    } else if (screenWidth < 480) {
      // Medium phones
      buttonHeight = 36;
      fontSize = 12;
      horizontalPadding = 10;
    } else if (screenWidth < 600) {
      // Large phones
      buttonHeight = 38;
      fontSize = 13;
      horizontalPadding = 12;
    } else {
      // Tablets and larger
      buttonHeight = 40;
      fontSize = 14;
      horizontalPadding = 14;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.filterBorder : AppColors.white,
          borderRadius: BorderRadius.circular(buttonHeight / 2),
          border:
              isSelected
                  ? null
                  : Border.all(
                    color: const Color(0xFFC4C4C4).withOpacity(0.4),
                    width: 1.5,
                  ),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.filterBorder,
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
