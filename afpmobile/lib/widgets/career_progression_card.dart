import 'package:flutter/material.dart';

class PromotionRequirement {
  final String label;
  final bool passed;
  PromotionRequirement({required this.label, required this.passed});
}

class CareerProgressionCard extends StatelessWidget {
  final String currentRank;
  final String nextRank;
  final String timeInRank;
  final double progress;
  final List<PromotionRequirement> requirements;
  const CareerProgressionCard({
    Key? key,
    required this.currentRank,
    required this.nextRank,
    required this.timeInRank,
    required this.progress,
    required this.requirements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Career Progression',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                // Current rank logo in rounded square
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(4),
                  child: Image.asset(
                    currentRank.toLowerCase().contains('staff sergeant')
                        ? 'assets/insignia/staff_sgt.png'
                        : 'assets/insignia/sgt.png',
                    width: 20,
                    height: 20,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Icon(Icons.shield, color: Colors.grey, size: 20),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  currentRank.replaceAll(RegExp(r'\s*\(.*?\)'), ''),
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Time in Rank: $timeInRank',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: Colors.grey[200],
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Promotion Requirements:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            SizedBox(height: 4),
            ...requirements.map(
              (req) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      req.passed ? Icons.check_circle : Icons.error_outline,
                      color: req.passed ? Colors.green : Colors.orange,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(req.label, style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Staff will validate if you have achieved the requirements for promotion.',
              style: TextStyle(
                fontSize: 13,
                color: const Color.fromARGB(221, 119, 119, 119),
              ),
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Next rank logo in rounded square
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFD600),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(4),
                  child: Image.asset(
                    nextRank.toLowerCase().contains('staff sergeant')
                        ? 'assets/insignia/staff_sgt.png'
                        : 'assets/insignia/sgt.png',
                    width: 20,
                    height: 20,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Icon(Icons.shield, color: Colors.grey, size: 20),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Next Rank:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(width: 4),
                Text(
                  nextRank,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF3E503A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
