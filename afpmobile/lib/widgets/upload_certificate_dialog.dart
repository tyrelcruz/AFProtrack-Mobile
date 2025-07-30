import 'package:flutter/material.dart';

class UploadCertificateDialog extends StatelessWidget {
  final VoidCallback? onTakePhoto;
  final VoidCallback? onBrowseFiles;

  const UploadCertificateDialog({
    Key? key,
    this.onTakePhoto,
    this.onBrowseFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 400, minWidth: 280),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F8F0), // Light green background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF4CAF50), // Darker green border
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Upload Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.upload_file,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            // Main Title
            const Text(
              'Choose a file or document',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Instructions
            const Text(
              'Use your camera or select from your gallery.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Format and Size Information
            const Text(
              'JPEG, PNG, and PDF formats up to 50 MB.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Action Buttons
            LayoutBuilder(
              builder: (context, constraints) {
                // If screen is too narrow, stack buttons vertically
                if (constraints.maxWidth < 300) {
                  return Column(
                    children: [
                      _ActionButton(
                        icon: Icons.camera_alt_outlined,
                        text: 'Take photo',
                        onTap: onTakePhoto,
                      ),
                      const SizedBox(height: 12),
                      _ActionButton(
                        icon: Icons.upload_file_outlined,
                        text: 'Browse Files',
                        onTap: onBrowseFiles,
                      ),
                    ],
                  );
                }
                // Otherwise, use horizontal layout
                return Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.camera_alt_outlined,
                        text: 'Take photo',
                        onTap: onTakePhoto,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.upload_file_outlined,
                        text: 'Browse Files',
                        onTap: onBrowseFiles,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
