import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
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
        name: 'Adv. Nadia Al-Salem',
        specialization: 'Corporate Law & Contracts',
        rating: 4.9,
        reviewCount: 156,
        avatarUrl: '',
        bio:
            'Corporate lawyer with 20 years of experience in investment law, mergers and acquisitions, and international trade agreements.',
        consultationFee: 200,
      ),
      LegalExpert(
        id: 'le2',
        name: 'Adv. Hassan Qureshi',
        specialization: 'Real Estate Law',
        rating: 4.7,
        reviewCount: 98,
        avatarUrl: '',
        bio:
            'Specialist in real estate transactions, property disputes, and construction contracts across the GCC.',
        consultationFee: 180,
      ),
      LegalExpert(
        id: 'le3',
        name: 'Adv. Maryam Al-Dosari',
        specialization: 'Intellectual Property',
        rating: 4.8,
        reviewCount: 72,
        avatarUrl: '',
        bio:
            'IP attorney focused on patent, trademark, and copyright protection for tech startups and entrepreneurs.',
        consultationFee: 250,
      ),
      LegalExpert(
        id: 'le4',
        name: 'Adv. Faisal Ibrahim',
        specialization: 'Financial Regulations',
        rating: 4.6,
        reviewCount: 115,
        avatarUrl: '',
        bio:
            'Expert in banking regulations, fintech compliance, and investment fund structuring.',
        consultationFee: 220,
      ),
    ];
  }

  List<Bank> _generateDemoBanks() {
    return const [
      Bank(
        id: 'b1',
        name: 'National Development Bank',
        logoUrl: '',
        description:
            'Government-backed development bank offering competitive SME financing.',
        interestRate: 3.5,
        fundingTypes: ['SME Loans', 'Project Finance', 'Working Capital'],
      ),
      Bank(
        id: 'b2',
        name: 'Gulf Commercial Bank',
        logoUrl: '',
        description:
            'Leading commercial bank with comprehensive business banking solutions.',
        interestRate: 4.2,
        fundingTypes: ['Business Loans', 'Trade Finance', 'Equipment Leasing'],
      ),
      Bank(
        id: 'b3',
        name: 'Islamic Finance House',
        logoUrl: '',
        description:
            'Shariah-compliant financial institution offering Murabaha and Musharakah products.',
        interestRate: 3.8,
        fundingTypes: ['Murabaha', 'Musharakah', 'Ijara'],
      ),
      Bank(
        id: 'b4',
        name: 'Innovation Capital Bank',
        logoUrl: '',
        description:
            'Specialized bank focused on startup and technology venture financing.',
        interestRate: 5.0,
        fundingTypes: ['Venture Debt', 'Startup Loans', 'Growth Capital'],
      ),
    ];
  }

  List<FundingApplication> _generateDemoApplications() {
    return [
      FundingApplication(
        id: 'fa1',
        bankName: 'National Development Bank',
        amount: 500000,
        purpose: 'Expand agricultural irrigation project',
        status: ApplicationStatus.approved,
        appliedAt: DateTime.now().subtract(const Duration(days: 30)),
        notes: 'Approved with 3.5% interest rate, 5-year term',
      ),
      FundingApplication(
        id: 'fa2',
        bankName: 'Gulf Commercial Bank',
        amount: 250000,
        purpose: 'Working capital for tech startup',
        status: ApplicationStatus.pending,
        appliedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      FundingApplication(
        id: 'fa3',
        bankName: 'Islamic Finance House',
        amount: 1000000,
        purpose: 'Real estate development project',
        status: ApplicationStatus.rejected,
        appliedAt: DateTime.now().subtract(const Duration(days: 45)),
        notes: 'Insufficient collateral provided',
      ),
    ];
  }
}
