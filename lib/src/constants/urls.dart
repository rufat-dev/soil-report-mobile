class Urls {
  static const mainEndpoint =
      'https://soil-repo-gcp-git-678290165816.europe-west1.run.app/';
  static const websiteUrl = 'https://soilreport.com/';

  // Firebase Identity Toolkit REST API
  static const firebaseApiKey = 'AIzaSyCICw8mcyYflzAQO-HoFOyJNYtFqW33sHg';
  static const firebaseIdentityBaseUrl =
      'https://identitytoolkit.googleapis.com/v1/';
  static const firebaseSecureTokenBaseUrl =
      'https://securetoken.googleapis.com/v1/';

  static String get firebaseSignInUrl =>
      '${firebaseIdentityBaseUrl}accounts:signInWithPassword?key=$firebaseApiKey';
  static String get firebaseSignUpUrl =>
      '${firebaseIdentityBaseUrl}accounts:signUp?key=$firebaseApiKey';
  static String get firebaseLookupUrl =>
      '${firebaseIdentityBaseUrl}accounts:lookup?key=$firebaseApiKey';
  static String get firebaseSendOobCodeUrl =>
      '${firebaseIdentityBaseUrl}accounts:sendOobCode?key=$firebaseApiKey';
  static String get firebaseRefreshTokenUrl =>
      '${firebaseSecureTokenBaseUrl}token?key=$firebaseApiKey';

  // Soil Report Backend
  static String get authBootstrapUrl => '${mainEndpoint}auth/bootstrap';

  /// POST Bearer; JSON body `fcm_token` string — persists token for AI worker push.
  static String get usersFcmTokenUrl => '${mainEndpoint}users/fcm-token';
  static String get usersMeUrl => '${mainEndpoint}users/me';
  static const devicesPath = 'devices';
  static const devicePath = 'device';
  static const groupsPath = 'groups';
  static const readingsPath = 'readings';
  static const deviceAnomaliesPath = 'device-anomalies';
  static const deviceStateLatestPath = 'device-state-latest';
  static const deviceTimeseriesHourlyPath = 'device-timeseries-hourly';
  static const deviceTrendsDailyPath = 'device-trends-daily';
  static const deviceOutOfRangeEventsPath = 'device-out-of-range-events';
  static const aiRecommendationsPath = 'ai-recommendations';
  static const aiForecastsPath = 'ai-forecasts';
  static const alertsPath = 'alerts';
  static const purchasesPath = 'purchases';
  static const classifierAlertTypesPath = 'classifiers/alert-types';
  static const classifierOperationStatusesPath =
      'classifiers/operation-statuses';
  static const classifierPlantsPath = 'classifiers/plants';
  static const classifierSoilsPath = 'classifiers/soils';
}
