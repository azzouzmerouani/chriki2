import 'package:equatable/equatable.dart';

enum ProgressStatus { ideaOnly, prototype, readyProject }

enum InvestmentType { equity, loan }

enum ProjectCategory {
  technology,
  agriculture,
  realEstate,
  healthcare,
  education,
  foodBeverage,
}

class IdeaProject extends Equatable {
  final String id;
  final String name;
  final String ideaTitle;
  final ProjectCategory category;
  final String briefDescription;
  final String problemStatement;
  final ProgressStatus progressStatus;
  final InvestmentType investmentType;
  final double requiredCapital;
  final List<String> imagesPaths;
  final List<String> videosPaths;
  final List<String> documentsPaths;
  final DateTime createdAt;

  const IdeaProject({
    required this.id,
    required this.name,
    required this.ideaTitle,
    required this.category,
    required this.briefDescription,
    required this.problemStatement,
    required this.progressStatus,
    required this.investmentType,
    required this.requiredCapital,
    this.imagesPaths = const [],
    this.videosPaths = const [],
    this.documentsPaths = const [],
    required this.createdAt,
  });

  factory IdeaProject.fromJson(Map<String, dynamic> json) {
    return IdeaProject(
      id: json['id'] as String,
      name: json['name'] as String,
      ideaTitle: json['idea_title'] as String,
      category: ProjectCategory.values[json['category'] as int],
      briefDescription: json['brief_description'] as String,
      problemStatement: json['problem_statement'] as String,
      progressStatus: ProgressStatus.values[json['progress_status'] as int],
      investmentType: InvestmentType.values[json['investment_type'] as int],
      requiredCapital: (json['required_capital'] as num).toDouble(),
      imagesPaths: List<String>.from(json['images_paths'] ?? []),
      videosPaths: List<String>.from(json['videos_paths'] ?? []),
      documentsPaths: List<String>.from(json['documents_paths'] ?? []),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'idea_title': ideaTitle,
      'category': category.index,
      'brief_description': briefDescription,
      'problem_statement': problemStatement,
      'progress_status': progressStatus.index,
      'investment_type': investmentType.index,
      'required_capital': requiredCapital,
      'images_paths': imagesPaths,
      'videos_paths': videosPaths,
      'documents_paths': documentsPaths,
      'created_at': createdAt.toIso8601String(),
    };
  }

  IdeaProject copyWith({
    String? id,
    String? name,
    String? ideaTitle,
    ProjectCategory? category,
    String? briefDescription,
    String? problemStatement,
    ProgressStatus? progressStatus,
    InvestmentType? investmentType,
    double? requiredCapital,
    List<String>? imagesPaths,
    List<String>? videosPaths,
    List<String>? documentsPaths,
    DateTime? createdAt,
  }) {
    return IdeaProject(
      id: id ?? this.id,
      name: name ?? this.name,
      ideaTitle: ideaTitle ?? this.ideaTitle,
      category: category ?? this.category,
      briefDescription: briefDescription ?? this.briefDescription,
      problemStatement: problemStatement ?? this.problemStatement,
      progressStatus: progressStatus ?? this.progressStatus,
      investmentType: investmentType ?? this.investmentType,
      requiredCapital: requiredCapital ?? this.requiredCapital,
      imagesPaths: imagesPaths ?? this.imagesPaths,
      videosPaths: videosPaths ?? this.videosPaths,
      documentsPaths: documentsPaths ?? this.documentsPaths,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    ideaTitle,
    category,
    briefDescription,
    problemStatement,
    progressStatus,
    investmentType,
    requiredCapital,
    imagesPaths,
    videosPaths,
    documentsPaths,
    createdAt,
  ];
}
