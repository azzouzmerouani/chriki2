import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/investor_model.dart';
import 'investor_state.dart';

class InvestorCubit extends Cubit<InvestorState> {
  InvestorCubit() : super(InvestorInitial());

  final List<Investor> _allInvestors = [];
  final List<InvestmentRecord> _records = [];

  void loadInvestors() {
    emit(InvestorLoading());
    if (_allInvestors.isEmpty) {
      _allInvestors.addAll(_generateDemoInvestors());
      _records.addAll(_generateDemoRecords());
    }
    emit(InvestorLoaded(_allInvestors));
  }

  void filterByInterest(String? interest) {
    if (interest == null || interest.isEmpty) {
      emit(InvestorLoaded(_allInvestors));
      return;
    }
    final filtered = _allInvestors
        .where(
          (i) => i.interests
              .map((e) => e.toLowerCase())
              .contains(interest.toLowerCase()),
        )
        .toList();
    emit(InvestorLoaded(filtered, activeFilter: interest));
  }

  void loadInvestorDetail(String investorId) {
    final investor = _allInvestors.firstWhere((i) => i.id == investorId);
    final records = _records.where((r) => r.investorId == investorId).toList();
    emit(InvestorDetailLoaded(investor, records));
  }

  void loadInvestmentSummary() {
    final total = _records.fold<double>(0, (sum, r) => sum + r.amount);
    final active = _records.where((r) => r.status == 'active').length;
    emit(
      InvestmentSummaryLoaded(
        records: _records,
        totalInvested: total,
        activeCount: active,
      ),
    );
  }

  List<Investor> _generateDemoInvestors() {
    return [
      const Investor(
        id: 'inv1',
        name: 'Abdullah Investment Group',
        bio:
            'Leading investment group focused on technology and agricultural innovations in the MENA region.',
        avatarUrl: '',
        interests: ['Technology', 'Agriculture'],
        totalInvested: 2500000,
        activeProjects: 8,
        rating: 4.8,
        location: 'Riyadh, KSA',
      ),
      const Investor(
        id: 'inv2',
        name: 'Gulf Capital Partners',
        bio:
            'Real estate and commercial development investment firm with 15 years of experience.',
        avatarUrl: '',
        interests: ['Real Estate', 'Technology'],
        totalInvested: 5000000,
        activeProjects: 12,
        rating: 4.6,
        location: 'Dubai, UAE',
      ),
      const Investor(
        id: 'inv3',
        name: 'Noor Ventures',
        bio:
            'Angel investor network specializing in healthcare and education startups.',
        avatarUrl: '',
        interests: ['Healthcare', 'Education'],
        totalInvested: 1200000,
        activeProjects: 5,
        rating: 4.9,
        location: 'Amman, Jordan',
      ),
      const Investor(
        id: 'inv4',
        name: 'Sahara Fund',
        bio:
            'Agricultural technology fund supporting sustainable farming initiatives across North Africa.',
        avatarUrl: '',
        interests: ['Agriculture', 'Food & Beverage'],
        totalInvested: 3000000,
        activeProjects: 10,
        rating: 4.7,
        location: 'Cairo, Egypt',
      ),
      const Investor(
        id: 'inv5',
        name: 'Digital Bridge Capital',
        bio:
            'FinTech-focused investment firm providing seed to Series B funding.',
        avatarUrl: '',
        interests: ['Technology', 'Education'],
        totalInvested: 4500000,
        activeProjects: 15,
        rating: 4.5,
        location: 'Bahrain',
      ),
    ];
  }

  List<InvestmentRecord> _generateDemoRecords() {
    return [
      InvestmentRecord(
        id: 'rec1',
        projectName: 'Smart Irrigation System',
        investorId: 'inv1',
        amount: 150000,
        date: DateTime.now().subtract(const Duration(days: 30)),
        status: 'active',
      ),
      InvestmentRecord(
        id: 'rec2',
        projectName: 'EduConnect Platform',
        investorId: 'inv3',
        amount: 300000,
        date: DateTime.now().subtract(const Duration(days: 60)),
        status: 'active',
      ),
      InvestmentRecord(
        id: 'rec3',
        projectName: 'Urban Living Project',
        investorId: 'inv2',
        amount: 500000,
        date: DateTime.now().subtract(const Duration(days: 90)),
        status: 'completed',
      ),
      InvestmentRecord(
        id: 'rec4',
        projectName: 'Green Delivery Fleet',
        investorId: 'inv5',
        amount: 200000,
        date: DateTime.now().subtract(const Duration(days: 15)),
        status: 'pending',
      ),
      InvestmentRecord(
        id: 'rec5',
        projectName: 'HealthTrack App',
        investorId: 'inv3',
        amount: 100000,
        date: DateTime.now().subtract(const Duration(days: 45)),
        status: 'active',
      ),
    ];
  }
}
