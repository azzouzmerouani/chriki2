import 'package:equatable/equatable.dart';

class SmartAlert extends Equatable {
  final String id;
  final String investorId;
  final String investorName;
  final String projectId;
  final String projectTitle;
  final String sector;
  final DateTime matchedAt;
  final bool isRead;

  const SmartAlert({
    required this.id,
    required this.investorId,
    required this.investorName,
    required this.projectId,
    required this.projectTitle,
    required this.sector,
    required this.matchedAt,
    this.isRead = false,
  });

  factory SmartAlert.fromJson(Map<String, dynamic> json) {
    return SmartAlert(
      id: json['id'] as String,
      investorId: json['investor_id'] as String,
      investorName: json['investor_name'] as String,
      projectId: json['project_id'] as String,
      projectTitle: json['project_title'] as String,
      sector: json['sector'] as String,
      matchedAt: DateTime.parse(json['matched_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'investor_id': investorId,
      'investor_name': investorName,
      'project_id': projectId,
      'project_title': projectTitle,
      'sector': sector,
      'matched_at': matchedAt.toIso8601String(),
      'is_read': isRead,
    };
  }

  SmartAlert copyWith({bool? isRead}) {
    return SmartAlert(
      id: id,
      investorId: investorId,
      investorName: investorName,
      projectId: projectId,
      projectTitle: projectTitle,
      sector: sector,
      matchedAt: matchedAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [
    id,
    investorId,
    investorName,
    projectId,
    projectTitle,
    sector,
    matchedAt,
    isRead,
  ];
}
