import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/home/domain/alerts/soil_alert_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alerts_screen_controller.g.dart';

@riverpod
class AlertsScreenController extends _$AlertsScreenController
    with MockableControllerMixin<AlertsScreenState> {
  @override
  AlertsScreenState build() {
    return const AlertsScreenState(
      checkState: null,
      alerts: [],
    );
  }

  @override
  AlertsScreenState get mockState => AlertsScreenState(
        checkState: const AsyncValue.data(null),
        alerts: _mockAlerts,
      );

  @override
  AlertsScreenState get mockLoadingState => const AlertsScreenState(
        checkState: AsyncValue.loading(),
        alerts: [],
      );

  Future<void> loadAlerts() async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    state = AlertsScreenState(
      checkState: const AsyncValue.data(null),
      alerts: _mockAlerts,
    );
  }

  Future<void> markAsRead(int id) async {
    final updated = state.alerts
        .map((a) => a.id == id ? a.copyWith(isRead: true) : a)
        .toList();
    state = state.copyWith(alerts: updated);
  }

  Future<void> dismissAlert(int id) async {
    final updated = state.alerts.where((a) => a.id != id).toList();
    state = state.copyWith(alerts: updated);
  }
}

class AlertsScreenState extends BaseState {
  final List<SoilAlertModel> alerts;

  const AlertsScreenState({
    super.checkState,
    required this.alerts,
  });

  AlertsScreenState copyWith({
    AsyncValue<String?>? checkState,
    List<SoilAlertModel>? alerts,
  }) {
    return AlertsScreenState(
      checkState: checkState ?? this.checkState,
      alerts: alerts ?? this.alerts,
    );
  }
}

final _mockAlerts = [
  SoilAlertModel(
    id: 1,
    title: 'Low Soil Moisture',
    description: 'Moisture in Field A – North has dropped below 20%. Irrigation recommended.',
    severity: SoilAlertSeverity.critical,
    siteLabel: 'Field A – North',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  SoilAlertModel(
    id: 2,
    title: 'pH Level Rising',
    description: 'pH in Greenhouse Plot reached 7.8. Consider adding sulfur-based amendments.',
    severity: SoilAlertSeverity.warning,
    siteLabel: 'Greenhouse Plot',
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  SoilAlertModel(
    id: 3,
    title: 'Nitrogen Deficiency Detected',
    description: 'Nitrogen levels in Field B – South are below optimal range (< 30 ppm).',
    severity: SoilAlertSeverity.warning,
    siteLabel: 'Field B – South',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  SoilAlertModel(
    id: 4,
    title: 'New Sample Processed',
    description: 'Lab results for sample #1042 from Field A – North are now available.',
    severity: SoilAlertSeverity.info,
    siteLabel: 'Field A – North',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    isRead: true,
  ),
];
