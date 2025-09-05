import 'package:flutter/material.dart';
import 'dart:async';
import 'app_colors.dart';

class FlushbarUtils {
  static OverlayEntry? _currentOverlay;

  /// Show a success flushbar from the top
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    _showFlushbar(
      context,
      message: message,
      title: title,
      backgroundColor: Colors.green.shade600,
      iconColor: Colors.white,
      textColor: Colors.white,
      icon: Icons.check_circle,
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show an error flushbar from the top
  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
  }) {
    _showFlushbar(
      context,
      message: message,
      title: title,
      backgroundColor: Colors.red.shade600,
      iconColor: Colors.white,
      textColor: Colors.white,
      icon: Icons.error,
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show a warning flushbar from the top
  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    _showFlushbar(
      context,
      message: message,
      title: title,
      backgroundColor: Colors.orange.shade600,
      iconColor: Colors.white,
      textColor: Colors.white,
      icon: Icons.warning,
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show an info flushbar from the top
  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    _showFlushbar(
      context,
      message: message,
      title: title,
      backgroundColor: AppColors.armyPrimary,
      iconColor: Colors.white,
      textColor: Colors.white,
      icon: Icons.info,
      duration: duration,
      onTap: onTap,
    );
  }

  /// Show a custom flushbar from the top
  static void showCustom(
    BuildContext context, {
    required String message,
    String? title,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    Color? iconColor,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    _showFlushbar(
      context,
      message: message,
      title: title,
      backgroundColor: backgroundColor,
      iconColor: iconColor ?? textColor,
      textColor: textColor,
      icon: icon,
      duration: duration,
      onTap: onTap,
    );
  }

  /// Internal method to show the flushbar
  static void _showFlushbar(
    BuildContext context, {
    required String message,
    String? title,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
    required IconData icon,
    required Duration duration,
    VoidCallback? onTap,
  }) {
    // Dismiss any existing flushbar
    dismiss();

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => _FlushbarWidget(
            message: message,
            title: title,
            backgroundColor: backgroundColor,
            iconColor: iconColor,
            textColor: textColor,
            icon: icon,
            onTap: onTap,
            onDismiss: () {
              overlayEntry.remove();
              _currentOverlay = null;
            },
          ),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);

    // Auto dismiss after duration
    Timer(duration, () {
      if (_currentOverlay == overlayEntry) {
        dismiss();
      }
    });
  }

  /// Dismiss the current flushbar
  static void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

class _FlushbarWidget extends StatefulWidget {
  final String message;
  final String? title;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const _FlushbarWidget({
    required this.message,
    this.title,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
    this.onTap,
    required this.onDismiss,
  });

  @override
  State<_FlushbarWidget> createState() => _FlushbarWidgetState();
}

class _FlushbarWidgetState extends State<_FlushbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: GestureDetector(
                  onTap: () {
                    widget.onTap?.call();
                    _dismiss();
                  },
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity != null &&
                        details.primaryVelocity!.abs() > 100) {
                      _dismiss();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(widget.icon, color: widget.iconColor, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.title != null) ...[
                                Text(
                                  widget.title!,
                                  style: TextStyle(
                                    color: widget.textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              Text(
                                widget.message,
                                style: TextStyle(
                                  color: widget.textColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _dismiss,
                          child: Icon(
                            Icons.close,
                            color: widget.textColor.withOpacity(0.7),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
