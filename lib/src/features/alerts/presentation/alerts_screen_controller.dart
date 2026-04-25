import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/alerts/data/alerts_repository.dart';
import 'package:soilreport/src/features/alerts/domain/soil_alert_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alerts_screen_controller.g.dart';

@riverpod
class AlertsScreenController extends _$AlertsScreenController
    with MockableControllerMixin<AlertsScreenState> {
  @override
  AlertsScreenState build() {
    return const AlertsScreenState(checkState: null, alerts: []);
  }

  @override
  AlertsScreenState get mockState => AlertsScreenState(
        checkState: const AsyncValue.data(null),
        alerts: _mockAlerts,
      );

  @override
  AlertsScreenState get mockLoadingState =>
      const AlertsScreenState(checkState: AsyncValue.loading(), alerts: []);

  Future<void> loadAlerts() async {
    state = state.copyWith(checkState: const AsyncValue.loading());
    try {
      final repo = ref.read(alertsRepositoryProvider);
      final rows = await repo.listAlerts(limit: 50);
      final alerts = <SoilAlertModel>[];
      for (final row in rows) {
        final aid = row.alertId?.trim();
        if (aid == null || aid.isEmpty) {
          continue;
        }
        final message = row.message ?? '';
        final title = (row.title != null && row.title!.trim().isNotEmpty)
            ? row.title!.trim()
            : _titleFromMessage(message);
        alerts.add(
          SoilAlertModel(
            id: aid,
            title: title,
            description: message,
            severity: _severityFromTitleOrMessage(title, message),
            siteLabel: row.deviceId?.trim().isNotEmpty == true
                ? row.deviceId!
                : 'Device',
            createdAt: row.createdAt ?? DateTime.now(),
            isRead: row.isRead == true,
          ),
        );
      }
      state = AlertsScreenState(
        checkState: const AsyncValue.data(null),
        alerts: alerts,
      );
    } catch (_) {
      state = AlertsScreenState(
        checkState: const AsyncValue.data(null),
        alerts: _mockAlerts,
      );
    }
  }

  Future<void> markAsRead(String id) async {
    final repo = ref.read(alertsRepositoryProvider);
    try {
      await repo.updateAlert(id, const AlertUpdateRequest(isRead: true));
    } catch (_) {
      /* ignore */
    }
    final updated =
        state.alerts.map((a) => a.id == id ? a.copyWith(isRead: true) : a).toList();
    state = state.copyWith(alerts: updated);
  }

  Future<void> dismissAlert(String id) async {
    final repo = ref.read(alertsRepositoryProvider);
    try {
      await repo.deleteAlert(id);
    } catch (_) {
      /* ignore */
    }
    final updated = state.alerts.where((a) => a.id != id).toList();
    state = state.copyWith(alerts: updated);
  }

  SoilAlertSeverity _severityFromTitleOrMessage(String title, String message) {
    final lower = '$title $message'.toLowerCase();
    if (lower.contains('critical') ||
        lower.contains('urgent') ||
        lower.contains('immediate')) {
      return SoilAlertSeverity.critical;
    }
    if (lower.contains('warning') || lower.contains('today')) {
      return SoilAlertSeverity.warning;
    }
    return SoilAlertSeverity.info;
  }

  static String _titleFromMessage(String message) {
    if (message.isEmpty) {
      return 'Alert';
    }
    final line = message.split('\n').first.trim();
    if (line.length <= 72) {
      return line;
    }
    return '${line.substring(0, 69)}…';
  }
}

class AlertsScreenState extends BaseState {
  final List<SoilAlertModel> alerts;

  const AlertsScreenState({super.checkState, required this.alerts});

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
    id: 'mock-1',
    title: 'Low Soil Moisture',
    description:
        'Moisture in Field A – North has dropped below 20%. Irrigation recommended.',
    severity: SoilAlertSeverity.critical,
    siteLabel: 'Field A – North',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
];
