import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/strings_const.dart';
import '../../data/models/legal_finance_model.dart';
import 'legal_finance_state.dart';

class LegalFinanceCubit extends Cubit<LegalFinanceState> {
  LegalFinanceCubit() : super(LegalFinanceInitial());

  final List<LegalExpert> _experts = [];
  final List<Bank> _banks = [];
  final List<FundingApplication> _applications = [];

  void loadExperts() {
    emit(LegalFinanceLoading());
    if (_experts.isEmpty) {
      _experts.addAll(_generateDemoExperts());
      _banks.addAll(_generateDemoBanks());
      _applications.addAll(_generateDemoApplications());
    }
    emit(LegalExpertsLoaded(_experts));
  }

  void loadExpertDetail(String expertId) {
    final expert = _experts.firstWhere((e) => e.id == expertId);
    emit(LegalExpertDetailLoaded(expert));
  }

  void loadBanks() {
    if (_banks.isEmpty) {
      _banks.addAll(_generateDemoBanks());
    }
    emit(BanksLoaded(_banks));
  }

  void loadApplications() {
    emit(FundingApplicationsLoaded(_applications));
  }

  Future<void> submitFundingApplication({
    required String bankName,
    required double amount,
    required String purpose,
  }) async {
    emit(FundingSubmitting());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final application = FundingApplication(
        id: const Uuid().v4(),
        bankName: bankName,
        amount: amount,
        purpose: purpose,
        status: ApplicationStatus.pending,
        appliedAt: DateTime.now(),
      );
      _applications.insert(0, application);
      emit(FundingSubmitted());
    } catch (e) {
      emit(LegalFinanceError(e.toString()));
    }
  }

  List<LegalExpert> _generateDemoExperts() {
    return const [
      LegalExpert(
        id: 'le1',
        name: StringsConst.legalExpert1Name,
        specialization: StringsConst.legalExpert1Specialization,
        rating: 4.9,
        reviewCount: 156,
        avatarUrl: '',
        bio: StringsConst.legalExpert1Bio,
        consultationFee: 200,
      ),
      LegalExpert(
        id: 'le2',
        name: StringsConst.legalExpert2Name,
        specialization: StringsConst.legalExpert2Specialization,
        rating: 4.7,
        reviewCount: 98,
        avatarUrl: '',
        bio: StringsConst.legalExpert2Bio,
        consultationFee: 180,
      ),
      LegalExpert(
        id: 'le3',
        name: StringsConst.legalExpert3Name,
        specialization: StringsConst.legalExpert3Specialization,
        rating: 4.8,
        reviewCount: 72,
        avatarUrl: '',
        bio: StringsConst.legalExpert3Bio,
        consultationFee: 250,
      ),
      LegalExpert(
        id: 'le4',
        name: StringsConst.legalExpert4Name,
        specialization: StringsConst.legalExpert4Specialization,
        rating: 4.6,
        reviewCount: 115,
        avatarUrl: '',
        bio: StringsConst.legalExpert4Bio,
        consultationFee: 220,
      ),
    ];
  }

  List<Bank> _generateDemoBanks() {
    return const [
      Bank(
        id: 'b1',
        name: StringsConst.bank1Name,
        logoUrl: '',
        description: StringsConst.bank1Description,
        interestRate: 3.5,
        fundingTypes: [
          StringsConst.bank1Type1,
          StringsConst.bank1Type2,
          StringsConst.bank1Type3,
        ],
      ),
      Bank(
        id: 'b2',
        name: StringsConst.bank2Name,
        logoUrl: '',
        description: StringsConst.bank2Description,
        interestRate: 4.2,
        fundingTypes: [
          StringsConst.bank2Type1,
          StringsConst.bank2Type2,
          StringsConst.bank2Type3,
        ],
      ),
      Bank(
        id: 'b3',
        name: StringsConst.bank3Name,
        logoUrl: '',
        description: StringsConst.bank3Description,
        interestRate: 3.8,
        fundingTypes: [
          StringsConst.bank3Type1,
          StringsConst.bank3Type2,
          StringsConst.bank3Type3,
        ],
      ),
      Bank(
        id: 'b4',
        name: StringsConst.bank4Name,
        logoUrl: '',
        description: StringsConst.bank4Description,
        interestRate: 5.0,
        fundingTypes: [
          StringsConst.bank4Type1,
          StringsConst.bank4Type2,
          StringsConst.bank4Type3,
        ],
      ),
    ];
  }

  List<FundingApplication> _generateDemoApplications() {
    return [
      FundingApplication(
        id: 'fa1',
        bankName: StringsConst.bank1Name,
        amount: 500000,
        purpose: StringsConst.demoFundingPurpose1,
        status: ApplicationStatus.approved,
        appliedAt: DateTime.now().subtract(const Duration(days: 30)),
        notes: StringsConst.demoFundingNote1,
      ),
      FundingApplication(
        id: 'fa2',
        bankName: StringsConst.bank2Name,
        amount: 250000,
        purpose: StringsConst.demoFundingPurpose2,
        status: ApplicationStatus.pending,
        appliedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      FundingApplication(
        id: 'fa3',
        bankName: StringsConst.bank3Name,
        amount: 1000000,
        purpose: StringsConst.demoFundingPurpose3,
        status: ApplicationStatus.rejected,
        appliedAt: DateTime.now().subtract(const Duration(days: 45)),
        notes: StringsConst.demoFundingNote2,
      ),
    ];
  }
}
