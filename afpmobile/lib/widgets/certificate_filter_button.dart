import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.filterBorder : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              isSelected
                  ? null
                  : Border.all(
                    color: const Color(0xFFC4C4C4).withOpacity(0.4),
                    width: 1.5,
                  ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.filterBorder,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
