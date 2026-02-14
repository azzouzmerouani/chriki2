import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/strings_const.dart';
import '../../data/models/real_estate_model.dart';
import 'real_estate_state.dart';

class RealEstateCubit extends Cubit<RealEstateState> {
  RealEstateCubit() : super(RealEstateInitial());

  final List<RealEstateProject> _projects = [];
  final List<RealEstateExpert> _experts = [];

  void loadProjects() {
    emit(RealEstateLoading());
    if (_projects.isEmpty) {
      _projects.addAll(_generateDemoProjects());
      _experts.addAll(_generateDemoExperts());
    }
    emit(RealEstateLoaded(_projects));
  }

  void filterByType(RealEstateType? type) {
    if (type == null) {
      emit(RealEstateLoaded(_projects));
      return;
    }
    final filtered = _projects.where((p) => p.type == type).toList();
    emit(RealEstateLoaded(filtered, activeFilter: type));
  }

  void loadProjectDetail(String projectId) {
    final project = _projects.firstWhere((p) => p.id == projectId);
    emit(RealEstateProjectDetailLoaded(project));
  }

  void loadCrowdfundingProjects() {
    final crowdfunding = _projects.where((p) => p.isCrowdfunding).toList();
    emit(CrowdfundingLoaded(crowdfunding));
  }

  void loadExperts() {
    emit(ExpertsLoaded(_experts));
  }

  List<RealEstateProject> _generateDemoProjects() {
    return [
      RealEstateProject(
        id: 're1',
        title: StringsConst.projectAlMurjanTitle.tr(),
        description: StringsConst.projectAlMurjanDesc.tr(),
        type: RealEstateType.residential,
        latitude: 36.7538,
        longitude: 3.0588,
        address: StringsConst.projectAlMurjanAddress.tr(),
        totalFunding: 500000000,
        currentFunding: 375000000,
        investorsCount: 45,
        minInvestment: 1000000,
        isCrowdfunding: true,
        bmcData: StringsConst.projectAlMurjanBmc.tr(),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      RealEstateProject(
        id: 're2',
        title: StringsConst.projectBusinessBayTitle.tr(),
        description: StringsConst.projectBusinessBayDesc.tr(),
        type: RealEstateType.commercial,
        latitude: 35.6969,
        longitude: -0.6331,
        address: StringsConst.projectBusinessBayAddress.tr(),
        totalFunding: 1200000000,
        currentFunding: 840000000,
        investorsCount: 78,
        minInvestment: 2500000,
        isCrowdfunding: true,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      RealEstateProject(
        id: 're3',
        title: StringsConst.projectGreenValleyTitle.tr(),
        description: StringsConst.projectGreenValleyDesc.tr(),
        type: RealEstateType.land,
        latitude: 36.4700,
        longitude: 2.8300,
        address: StringsConst.projectGreenValleyAddress.tr(),
        totalFunding: 200000000,
        currentFunding: 80000000,
        investorsCount: 20,
        minInvestment: 500000,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      RealEstateProject(
        id: 're4',
        title: StringsConst.projectHeritageVillaTitle.tr(),
        description: StringsConst.projectHeritageVillaDesc.tr(),
        type: RealEstateType.renovation,
        latitude: 36.7850,
        longitude: 3.0600,
        address: StringsConst.projectHeritageVillaAddress.tr(),
        totalFunding: 150000000,
        currentFunding: 120000000,
        investorsCount: 35,
        minInvestment: 300000,
        isCrowdfunding: true,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      RealEstateProject(
        id: 're5',
        title: StringsConst.projectMarinaHeightsTitle.tr(),
        description: StringsConst.projectMarinaHeightsDesc.tr(),
        type: RealEstateType.residential,
        latitude: 36.8974,
        longitude: 7.7561,
        address: StringsConst.projectMarinaHeightsAddress.tr(),
        totalFunding: 800000000,
        currentFunding: 400000000,
        investorsCount: 55,
        minInvestment: 1500000,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
  }

  List<RealEstateExpert> _generateDemoExperts() {
    return [
      RealEstateExpert(
        id: 'exp1',
        name: StringsConst.expertOmarName.tr(),
        specialization: StringsConst.expertOmarSpec.tr(),
        rating: 4.9,
        reviewCount: 128,
        avatarUrl: '',
        bio: StringsConst.expertOmarBio.tr(),
      ),
      RealEstateExpert(
        id: 'exp2',
        name: StringsConst.expertLaylaName.tr(),
        specialization: StringsConst.expertLaylaSpec.tr(),
        rating: 4.7,
        reviewCount: 95,
        avatarUrl: '',
        bio: StringsConst.expertLaylaBio.tr(),
      ),
      RealEstateExpert(
        id: 'exp3',
        name: StringsConst.expertTariqName.tr(),
        specialization: StringsConst.expertTariqSpec.tr(),
        rating: 4.8,
        reviewCount: 110,
        avatarUrl: '',
        bio: StringsConst.expertTariqBio.tr(),
      ),
    ];
  }
}
