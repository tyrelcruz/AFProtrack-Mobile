class HomeTrainingProgram {
  final String title;
  final String instructor;
  final double progress;
  final String grade;
  final DateTime? nextSession;
  final String status;

  const HomeTrainingProgram({
    required this.title,
    required this.instructor,
    required this.progress,
    required this.grade,
    this.nextSession,
    required this.status,
  });
}
