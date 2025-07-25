import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

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
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: width * 0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 2),
            Text(
              '$rank - $unit',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            SizedBox(height: 2),
            Text(
              'Service ID: $serviceId',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
                fontSize: 13,
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
                        fontSize: 20,
                      ),
                    ),
                    Text('Training Progress', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Container(width: 1, height: 32, color: Colors.grey[300]),
                Column(
                  children: [
                    Text(
                      '$readinessLevel%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text('Readiness Level', style: TextStyle(fontSize: 12)),
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
