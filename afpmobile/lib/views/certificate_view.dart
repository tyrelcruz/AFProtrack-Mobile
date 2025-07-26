import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../utils/app_colors.dart';

class CertificateView extends StatefulWidget {
  const CertificateView({Key? key}) : super(key: key);

  @override
  State<CertificateView> createState() => _CertificateViewState();
}

class _CertificateViewState extends State<CertificateView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: const AppBarWidget(title: 'Certificates', showLeading: false),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Certificates',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your certificates will appear here',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
