import 'package:flutter/material.dart';
import '../models/training_program.dart';

class TrainingProgramCard extends StatelessWidget {
  final TrainingProgram program;
  final Color cardColor;
  const TrainingProgramCard({
    Key? key,
    required this.program,
    this.cardColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: width * 0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.18),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    program.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    program.status,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Instructor: ${program.instructor}',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Progress', style: TextStyle(fontSize: 12)),
                Spacer(),
                Text(
                  '${(program.progress * 100).toInt()}%',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            SizedBox(height: 2),
            LinearProgressIndicator(
              value: program.progress,
              minHeight: 7,
              backgroundColor: Colors.grey[200],
              color: Colors.green[700],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Spacer(),
                Text(
                  'Grade: ${program.grade}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (program.nextSession != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  'Next Session: ${program.nextSession}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
