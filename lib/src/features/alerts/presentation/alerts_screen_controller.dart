import 'package:flutter/foundation.dart';
import 'package:soilreport/src/core/data/base_state.dart';
import 'package:soilreport/src/core/data/mockable_controller_mixin.dart';
import 'package:soilreport/src/features/alerts/data/alerts_repository.dart';
import 'package:soilreport/src/features/alerts/domain/soil_alert_model.dart';
import 'package:soilreport/src/features/home/data/dashboard_devices_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alerts_screen_controller.g.dart';

@riverpod
class AlertsScreenController extends _$AlertsScreenController
    with MockableControllerMixin<AlertsScreenState> {
  @override
  AlertsScreenState build() {
    return const AlertsScreenState(checkState: null, alerts: [], hasLoadError: false);
  }

  @override
  AlertsScreenState get mockState => AlertsScreenState(
        checkState: const AsyncValue.data(null),
        alerts: _mockAlerts,
        hasLoadError: false,
      );

  @override
  AlertsScreenState get mockLoadingState =>
      const AlertsScreenState(checkState: AsyncValue.loading(), alerts: [], hasLoadError: false);

  /// When [forceRemote] is true (e.g. pull-to-refresh), skips local cache so the
  /// API is hit again. Otherwise cached alerts (up to 5 min) can return instantly.
  Future<void> loadAlerts({bool forceRemote = false}) async {
    state = state.copyWith(checkState: const AsyncValue.loading(), hasLoadError: false);
    try {
      final devicesRepo = ref.read(dashboardDevicesRepositoryProvider);
      final devices = await devicesRepo.getDevices(useCache: !forceRemote);
      final deviceNameById = {
        for (final d in devices)
          d.deviceId: (d.deviceName?.trim().isNotEmpty ?? false)
              ? d.deviceName!.trim()
              : d.deviceId,
      };

      final repo = ref.read(alertsRepositoryProvider);
      final rows = await repo.listAlerts(limit: 50, useCache: !forceRemote);
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
            siteLabel: _formatDeviceLabel(row.deviceId, deviceNameById),
            createdAt: row.createdAt ?? DateTime.now(),
            isRead: row.isRead == true,
          ),
        );
      }
      alerts.sort((a, b) {
        if (a.isRead != b.isRead) {
          return a.isRead ? 1 : -1;
        }
        return b.createdAt.compareTo(a.createdAt);
      });
      state = AlertsScreenState(
        checkState: const AsyncValue.data(null),
        alerts: alerts,
        hasLoadError: false,
      );
    } catch (e, st) {
      debugPrint('Alerts load failed: $e');
      debugPrintStack(stackTrace: st);
      state = AlertsScreenState(
        checkState: const AsyncValue.data(null),
        alerts: const [],
        hasLoadError: true,
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

  String _formatDeviceLabel(String? deviceId, Map<String, String> deviceNameById) {
    if (deviceId == null || deviceId.isEmpty) {
      return 'All devices';
    }
    final name = deviceNameById[deviceId];
    if (name == null || name == deviceId) {
      return 'Device ${_shortDeviceId(deviceId)}';
    }
    return '$name (${_shortDeviceId(deviceId)})';
  }

  String _shortDeviceId(String id) {
    if (id.length <= 8) return id;
    return '${id.substring(0, 4)}…${id.substring(id.length - 4)}';
  }
}

class AlertsScreenState extends BaseState {
  final List<SoilAlertModel> alerts;
  final bool hasLoadError;

  const AlertsScreenState({
    super.checkState,
    required this.alerts,
    required this.hasLoadError,
  });

  AlertsScreenState copyWith({
    AsyncValue<String?>? checkState,
    List<SoilAlertModel>? alerts,
    bool? hasLoadError,
  }) {
    return AlertsScreenState(
      checkState: checkState ?? this.checkState,
      alerts: alerts ?? this.alerts,
      hasLoadError: hasLoadError ?? this.hasLoadError,
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
