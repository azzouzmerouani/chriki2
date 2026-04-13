import 'package:equatable/equatable.dart';

enum UniversityIdeaField {
  technology,
  agriculture,
  energies,
  healthcare,
  ai,
  industries,
  other,
}

enum UniversityIdeaProgress { ideaOnly, prototype, readyForExecution }

enum InvestmentReadiness { low, medium, high }

class UniversityIdea extends Equatable {
  final String id;
  final String title;
  final UniversityIdeaField field;
  final String problem;
  final String solution;
  final UniversityIdeaProgress progress;
  final InvestmentReadiness readiness;
  final String incubatorName;
  final String universityName;
  final bool hideStudentName;
  final bool lockDetails;

  const UniversityIdea({
    required this.id,
    required this.title,
    required this.field,
    required this.problem,
    required this.solution,
    required this.progress,
    required this.readiness,
    required this.incubatorName,
    required this.universityName,
    this.hideStudentName = true,
    this.lockDetails = true,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    field,
    problem,
    solution,
    progress,
    readiness,
    incubatorName,
    universityName,
    hideStudentName,
    lockDetails,
  ];
}
