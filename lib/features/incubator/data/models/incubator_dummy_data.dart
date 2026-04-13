import 'university_idea_model.dart';
import '../../../../core/constants/strings_const.dart';

class IncubatorProjectItem {
  final String id;
  final String titleKey;
  final String summaryKey;
  final UniversityIdeaField field;
  final String readinessKey;
  final String statusKey;
  final String imageKeyword;

  const IncubatorProjectItem({
    required this.id,
    required this.titleKey,
    required this.summaryKey,
    required this.field,
    required this.readinessKey,
    required this.statusKey,
    required this.imageKeyword,
  });
}

class IncubatorStudentItem {
  final String id;
  final String nameKey;
  final String trackKey;
  final String projectId;
  final String imageKeyword;

  const IncubatorStudentItem({
    required this.id,
    required this.nameKey,
    required this.trackKey,
    required this.projectId,
    required this.imageKeyword,
  });
}

class IncubatorDummyData {
  static const projects = <IncubatorProjectItem>[
    IncubatorProjectItem(
      id: 'p1',
      titleKey: StringsConst.incubatorProject1Title,
      summaryKey: StringsConst.incubatorProject1Summary,
      field: UniversityIdeaField.agriculture,
      readinessKey: 'medium',
      statusKey: 'pending',
      imageKeyword: 'smart irrigation agriculture technology',
    ),
    IncubatorProjectItem(
      id: 'p2',
      titleKey: StringsConst.incubatorProject2Title,
      summaryKey: StringsConst.incubatorProject2Summary,
      field: UniversityIdeaField.healthcare,
      readinessKey: 'high',
      statusKey: 'approved',
      imageKeyword: 'digital healthcare students',
    ),
    IncubatorProjectItem(
      id: 'p3',
      titleKey: StringsConst.incubatorProject3Title,
      summaryKey: StringsConst.incubatorProject3Summary,
      field: UniversityIdeaField.ai,
      readinessKey: 'high',
      statusKey: 'pending',
      imageKeyword: 'artificial intelligence education',
    ),
    IncubatorProjectItem(
      id: 'p4',
      titleKey: StringsConst.incubatorProject4Title,
      summaryKey: StringsConst.incubatorProject4Summary,
      field: UniversityIdeaField.energies,
      readinessKey: 'medium',
      statusKey: 'pending',
      imageKeyword: 'renewable energy batteries',
    ),
    IncubatorProjectItem(
      id: 'p5',
      titleKey: StringsConst.incubatorProject5Title,
      summaryKey: StringsConst.incubatorProject5Summary,
      field: UniversityIdeaField.industries,
      readinessKey: 'low',
      statusKey: 'pending',
      imageKeyword: 'food supply chain innovation',
    ),
  ];

  static const students = <IncubatorStudentItem>[
    IncubatorStudentItem(
      id: 's1',
      nameKey: StringsConst.incubatorStudent1Name,
      trackKey: 'technology',
      projectId: 'p1',
      imageKeyword: 'woman student portrait',
    ),
    IncubatorStudentItem(
      id: 's2',
      nameKey: StringsConst.incubatorStudent2Name,
      trackKey: 'healthcare',
      projectId: 'p2',
      imageKeyword: 'male medical student',
    ),
    IncubatorStudentItem(
      id: 's3',
      nameKey: StringsConst.incubatorStudent3Name,
      trackKey: 'ai',
      projectId: 'p3',
      imageKeyword: 'student laptop portrait',
    ),
    IncubatorStudentItem(
      id: 's4',
      nameKey: StringsConst.incubatorStudent4Name,
      trackKey: 'agriculture',
      projectId: 'p1',
      imageKeyword: 'young man agriculture student',
    ),
    IncubatorStudentItem(
      id: 's5',
      nameKey: StringsConst.incubatorStudent5Name,
      trackKey: 'energies',
      projectId: 'p4',
      imageKeyword: 'female engineering student portrait',
    ),
    IncubatorStudentItem(
      id: 's6',
      nameKey: StringsConst.incubatorStudent6Name,
      trackKey: 'industries',
      projectId: 'p5',
      imageKeyword: 'industrial design student',
    ),
    IncubatorStudentItem(
      id: 's7',
      nameKey: StringsConst.incubatorStudent7Name,
      trackKey: 'technology',
      projectId: 'p3',
      imageKeyword: 'female tech student portrait',
    ),
    IncubatorStudentItem(
      id: 's8',
      nameKey: StringsConst.incubatorStudent8Name,
      trackKey: 'healthcare',
      projectId: 'p2',
      imageKeyword: 'medical engineering student',
    ),
    IncubatorStudentItem(
      id: 's9',
      nameKey: StringsConst.incubatorStudent9Name,
      trackKey: 'energies',
      projectId: 'p4',
      imageKeyword: 'energy researcher student',
    ),
    IncubatorStudentItem(
      id: 's10',
      nameKey: StringsConst.incubatorStudent10Name,
      trackKey: 'industries',
      projectId: 'p5',
      imageKeyword: 'business student portrait',
    ),
  ];

  static IncubatorProjectItem projectById(String id) {
    return projects.firstWhere(
      (project) => project.id == id,
      orElse: () => projects.first,
    );
  }

  static IncubatorStudentItem studentById(String id) {
    return students.firstWhere(
      (student) => student.id == id,
      orElse: () => students.first,
    );
  }
}
