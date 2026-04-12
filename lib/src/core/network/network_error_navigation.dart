/// Central handling for "no internet" cases that should show [AuthAlertScreen].
///
/// Two cases are covered:
///
/// 1. **No connectivity** (device reports no wifi/cellular):
///    Handled in the router redirect via connectivity_plus → redirect to
///    [authAlertNetworkErrorPath].
///
/// 2. **Connected but no internet** (wifi/cellular reported but requests fail):
///    - Connection timeout, connection error, send/receive timeout from Dio
///    - Handled by the Dio interceptor → [notifyInternalNetworkError] →
///      set pending flag + invoke callback → redirect uses flag to send to
///      [authAlertInternalNetworkErrorPath].
///
/// Fail-safety:
/// - Pending flag is set before the callback so if the callback isn't set yet
///   (e.g. timeout during app init before [MyApp] builds), the next redirect
///   still sends the user to the internal-network-error alert.
/// - Redirect always checks the pending flag first so auth refresh or other
///   redirects cannot override the "show alert" decision.
/// - All HTTP calls must use the shared [Dio] from dio_provider so the
///   interceptor runs (repositories pass it into [RestService]).

/// Path to auth alert with [AuthAlertType.internalNetworkError].
/// Use for: connection timeout, connection error, send/receive timeout.
const String authAlertInternalNetworkErrorPath =
    '/auth/alert?alertType=internalNetworkError';

/// Path to auth alert with [AuthAlertType.networkError].
/// Use when: connectivity_plus reports no wifi/cellular.
const String authAlertNetworkErrorPath = '/auth/alert?alertType=networkError';

void Function()? _onInternalNetworkError;
bool _pendingInternalNetworkError = false;

void setOnInternalNetworkError(void Function()? callback) {
  _onInternalNetworkError = callback;
}

/// Called by the Dio interceptor on connection/timeout errors. Sets the
/// pending flag (so redirect can send to alert even if callback isn't set yet)
/// and invokes the app callback to navigate.
void notifyInternalNetworkError() {
  _pendingInternalNetworkError = true;
  _onInternalNetworkError?.call();
}

bool get hasPendingInternalNetworkError => _pendingInternalNetworkError;

void clearPendingInternalNetworkError() {
  _pendingInternalNetworkError = false;
}
