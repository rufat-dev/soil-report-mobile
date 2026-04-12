class Urls {
  static const mainEndpoint = 'https://soil-repo-gcp-git-678290165816.europe-west1.run.app/';
  static const clientPortalApiUrl = 'api/';
  static const websiteUrl = 'https://soilreport.com/';

  // Firebase Identity Toolkit REST API
  static const firebaseApiKey = 'AIzaSyCICw8mcyYflzAQO-HoFOyJNYtFqW33sHg';
  static const firebaseIdentityBaseUrl = 'https://identitytoolkit.googleapis.com/v1/';
  static const firebaseSecureTokenBaseUrl = 'https://securetoken.googleapis.com/v1/';

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
}
