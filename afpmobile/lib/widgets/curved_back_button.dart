import 'package:flutter/material.dart';

class CurvedBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double width;
  final double height;

  const CurvedBackButton({
    Key? key,
    this.onPressed,
    this.text = 'Back to Login',
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.iconColor = Colors.black87,
    this.width = 140,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        child: CustomPaint(
          painter: CurvedBackButtonPainter(
            backgroundColor: backgroundColor,
            strokeColor: Colors.grey.shade300,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back,
                color: iconColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
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

class CurvedBackButtonPainter extends CustomPainter {
  final Color backgroundColor;
  final Color strokeColor;

  CurvedBackButtonPainter({
    required this.backgroundColor,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    
    // Create a curved button shape with rounded corners and a slight curve
    final radius = size.height / 2;
    
    // Start from the left side
    path.moveTo(radius, 0);
    
    // Top edge with slight curve
    path.quadraticBezierTo(
      size.width * 0.3, 
      0, 
      size.width * 0.7, 
      0
    );
    
    // Right side curve
    path.quadraticBezierTo(
      size.width, 
      0, 
      size.width, 
      radius
    );
    
    // Bottom edge with slight curve
    path.quadraticBezierTo(
      size.width, 
      size.height, 
      size.width * 0.7, 
      size.height
    );
    
    // Left side curve
    path.quadraticBezierTo(
      size.width * 0.3, 
      size.height, 
      radius, 
      size.height
    );
    
    // Complete the left side
    path.quadraticBezierTo(
      0, 
      size.height, 
      0, 
      radius
    );
    
    // Complete the top left
    path.quadraticBezierTo(
      0, 
      0, 
      radius, 
      0
    );
    
    path.close();

    // Draw the background
    canvas.drawPath(path, paint);
    
    // Draw the stroke
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 