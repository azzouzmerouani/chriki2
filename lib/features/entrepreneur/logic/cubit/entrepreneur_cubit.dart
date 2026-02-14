import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/idea_project_model.dart';
import 'entrepreneur_state.dart';

class EntrepreneurCubit extends Cubit<EntrepreneurState> {
  EntrepreneurCubit() : super(EntrepreneurInitial());

  final List<IdeaProject> _projects = [];

  void loadProjects() {
    emit(EntrepreneurLoading());
    // Simulate loading with demo data
    if (_projects.isEmpty) {
      _projects.addAll(_generateDemoProjects());
    }
    emit(EntrepreneurLoaded(List.from(_projects)));
  }

  Future<void> submitProject({
    required String name,
    required String ideaTitle,
    required ProjectCategory category,
    required String briefDescription,
    required String problemStatement,
    required ProgressStatus progressStatus,
    required InvestmentType investmentType,
    required double requiredCapital,
    List<String> imagesPaths = const [],
    List<String> videosPaths = const [],
    List<String> documentsPaths = const [],
  }) async {
    emit(EntrepreneurSubmitting());

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API

      final project = IdeaProject(
        id: const Uuid().v4(),
        name: name,
        ideaTitle: ideaTitle,
        category: category,
        briefDescription: briefDescription,
        problemStatement: problemStatement,
        progressStatus: progressStatus,
        investmentType: investmentType,
        requiredCapital: requiredCapital,
        imagesPaths: imagesPaths,
        videosPaths: videosPaths,
        documentsPaths: documentsPaths,
        createdAt: DateTime.now(),
      );

      _projects.insert(0, project);
      emit(EntrepreneurSubmitted());
      emit(EntrepreneurLoaded(List.from(_projects)));
    } catch (e) {
      emit(EntrepreneurError(e.toString()));
    }
  }

  List<IdeaProject> _generateDemoProjects() {
    return [
      IdeaProject(
        id: '1',
        name: 'Ahmed Al-Rashid',
        ideaTitle: 'Smart Irrigation System',
        category: ProjectCategory.agriculture,
        briefDescription:
            'AI-powered irrigation system that reduces water usage by 40% using soil sensors and weather prediction.',
        problemStatement:
            'Farmers waste significant water resources due to inefficient traditional irrigation methods.',
        progressStatus: ProgressStatus.prototype,
        investmentType: InvestmentType.equity,
        requiredCapital: 150000,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      IdeaProject(
        id: '2',
        name: 'Sara Mohamed',
        ideaTitle: 'EduConnect Platform',
        category: ProjectCategory.education,
        briefDescription:
            'Online platform connecting students with tutors across the Arab world with AI-matched learning paths.',
        problemStatement:
            'Students in remote areas lack access to quality education and personalized tutoring.',
        progressStatus: ProgressStatus.readyProject,
        investmentType: InvestmentType.equity,
        requiredCapital: 300000,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      IdeaProject(
        id: '3',
        name: 'Khalid Nasser',
        ideaTitle: 'Green Delivery Fleet',
        category: ProjectCategory.technology,
        briefDescription:
            'Electric vehicle delivery service for last-mile logistics in urban centers.',
        problemStatement:
            'High carbon emissions from conventional delivery vehicles in city centers.',
        progressStatus: ProgressStatus.ideaOnly,
        investmentType: InvestmentType.loan,
        requiredCapital: 500000,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      IdeaProject(
        id: '4',
        name: 'Fatima Hassan',
        ideaTitle: 'HealthTrack App',
        category: ProjectCategory.healthcare,
        briefDescription:
            'Wearable-integrated health monitoring app for chronic disease patients with doctor dashboard.',
        problemStatement:
            'Chronic disease patients struggle with consistent health monitoring and doctor communication.',
        progressStatus: ProgressStatus.prototype,
        investmentType: InvestmentType.equity,
        requiredCapital: 200000,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }
}
