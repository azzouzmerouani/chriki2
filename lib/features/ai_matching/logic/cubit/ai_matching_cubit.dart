import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/strings_const.dart';
import '../../data/models/smart_alert_model.dart';
import 'ai_matching_state.dart';

/// AI Matching Engine Cubit
///
/// Business Logic:
/// When a new project is posted in a sector (e.g., Agriculture),
/// the engine scans all registered investors and matches those
/// whose interests include the same sector. Matched results are
/// stored as SmartAlerts and can trigger push notifications.
class AiMatchingCubit extends Cubit<AiMatchingState> {
  AiMatchingCubit() : super(AiMatchingInitial());

  final List<SmartAlert> _alerts = [];

  void loadAlerts() {
    emit(AiMatchingLoading());
    if (_alerts.isEmpty) {
      _alerts.addAll(_generateDemoAlerts());
    }
    final unread = _alerts.where((a) => !a.isRead).length;
    emit(AiMatchingLoaded(alerts: List.from(_alerts), unreadCount: unread));
  }

  void markAsRead(String alertId) {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(isRead: true);
      final unread = _alerts.where((a) => !a.isRead).length;
      emit(AiMatchingLoaded(alerts: List.from(_alerts), unreadCount: unread));
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _alerts.length; i++) {
      _alerts[i] = _alerts[i].copyWith(isRead: true);
    }
    emit(AiMatchingLoaded(alerts: List.from(_alerts), unreadCount: 0));
  }

  /// Core matching logic:
  /// Given a new project with a sector, find all investors
  /// whose interests include that sector and create alerts.
  List<SmartAlert> matchProjectToInvestors({
    required String projectId,
    required String projectTitle,
    required String sector,
    required List<Map<String, dynamic>> investors,
  }) {
    final matches = <SmartAlert>[];

    for (final investor in investors) {
      final interests = List<String>.from(investor['interests'] ?? []);
      final hasMatch = interests
          .map((i) => i.toLowerCase())
          .contains(sector.toLowerCase());

      if (hasMatch) {
        final alert = SmartAlert(
          id: 'alert_${DateTime.now().millisecondsSinceEpoch}_${investor['id']}',
          investorId: investor['id'] as String,
          investorName: investor['name'] as String,
          projectId: projectId,
          projectTitle: projectTitle,
          sector: sector,
          matchedAt: DateTime.now(),
        );
        matches.add(alert);
        _alerts.insert(0, alert);
      }
    }

    if (matches.isNotEmpty) {
      final unread = _alerts.where((a) => !a.isRead).length;
      emit(AiMatchingLoaded(alerts: List.from(_alerts), unreadCount: unread));
    }

    return matches;
  }

  List<SmartAlert> _generateDemoAlerts() {
    return [
      SmartAlert(
        id: 'sa1',
        investorId: 'inv1',
        investorName: StringsConst.smartAlertInvestor1,
        projectId: '1',
        projectTitle: StringsConst.smartAlertProject1,
        sector: 'Agriculture',
        matchedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      SmartAlert(
        id: 'sa2',
        investorId: 'inv5',
        investorName: StringsConst.smartAlertInvestor2,
        projectId: '3',
        projectTitle: StringsConst.smartAlertProject2,
        sector: 'Technology',
        matchedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      SmartAlert(
        id: 'sa3',
        investorId: 'inv3',
        investorName: StringsConst.smartAlertInvestor3,
        projectId: '2',
        projectTitle: StringsConst.smartAlertProject3,
        sector: 'Education',
        matchedAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      SmartAlert(
        id: 'sa4',
        investorId: 'inv2',
        investorName: StringsConst.smartAlertInvestor4,
        projectId: 're1',
        projectTitle: StringsConst.smartAlertProject4,
        sector: 'Real Estate',
        matchedAt: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      SmartAlert(
        id: 'sa5',
        investorId: 'inv4',
        investorName: StringsConst.smartAlertInvestor5,
        projectId: '4',
        projectTitle: StringsConst.smartAlertProject5,
        sector: 'Healthcare',
        matchedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
