// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Soil Report';

  @override
  String get commonSignIn => 'Sign In';

  @override
  String get commonPin => 'PIN';

  @override
  String get commonPassword => 'Password';

  @override
  String get commonNext => 'Next';

  @override
  String get commonClose => 'Close';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonLanguage => 'Language';

  @override
  String get commonLogout => 'Log Out';

  @override
  String get commonAppTitle => 'Soil Report';

  @override
  String get authAlertNetworkError =>
      'No network connection. Please check your internet and try again.';

  @override
  String get authAlertInternalNetworkError =>
      'Unable to reach the server. Please try again later.';

  @override
  String get authAlertUnknown =>
      'An unexpected error occurred. Please try again.';

  @override
  String get authAlertHasConnection => 'Connection restored. Proceeding...';

  @override
  String get authRetry => 'Retry';

  @override
  String get authProceed => 'Proceed';

  @override
  String get splashPlantCaption => 'Welcome to Soil Report';

  @override
  String get splashPlantMessage =>
      'Monitor your soil health, track samples, and receive actionable recommendations — all in one place.';

  @override
  String get splashMonitorCaption => 'Field Analysis';

  @override
  String get splashMonitorMessage =>
      'Collect and track soil samples across all your field sites with GPS precision.';

  @override
  String get splashHarvestCaption => 'Site Monitoring';

  @override
  String get splashHarvestMessage =>
      'Keep an eye on pH, moisture, nutrients, and organic matter for every plot you manage.';

  @override
  String get splashDataCaption => 'Smart Recommendations';

  @override
  String get splashDataMessage =>
      'Get AI-driven suggestions for fertilization, irrigation, and soil amendments tailored to your fields.';

  @override
  String get landingPageNewUser => 'New user?';

  @override
  String get landingPageCreateAccount => 'Create Account';

  @override
  String get pinPageEnterPin => 'Enter your PIN';

  @override
  String get pinPageEntryPin => 'PIN';

  @override
  String get pinPageAcceptTermsAndConditions =>
      'By signing in you accept the Terms & Conditions';

  @override
  String get passCodePageFingerPrintHeader => 'Use biometrics to sign in';

  @override
  String get loginPageForgotPassword => 'Forgot password?';

  @override
  String get loginPageRenewPassword => 'Reset Password';

  @override
  String get phoneNumberPageEnterPhoneNumber => 'Enter your phone number';

  @override
  String get phoneVerifyPageOtpCodeSent =>
      'A verification code has been sent to your phone.';

  @override
  String get phoneVerifyPageEnterOptCode => 'Enter verification code';

  @override
  String get phoneVerifyPageSmsTimerInfo => 'Didn\'t receive a code? Resend in';

  @override
  String get phoneVerifyPageResendSms => 'Resend Code';

  @override
  String get resetPasswordPageRepeatPassword => 'New Password';

  @override
  String get resetPasswordPageConfirmNewPassword => 'Confirm New Password';

  @override
  String get resetPasswordPageConfirmPassword => 'Confirm';

  @override
  String get dashboardPageTitle => 'Home';

  @override
  String get dashboardPageHi => 'Hi';

  @override
  String get dashboardPageWelcome => 'Welcome back!';

  @override
  String get dashboardPagePeriodCount => 'Periods';

  @override
  String get dashboardPagePolicies => 'Policies';

  @override
  String get dashboardPageNoClaimsDaysCount => 'No-claims days';

  @override
  String get dashboardPagePendingSignCount => 'pending documents';

  @override
  String get dashboardPageUrgentSignFile => 'Urgent: Sign required';

  @override
  String get dashboardPageViewAllSignDocs => 'View All';

  @override
  String get tab1Title => 'Statistics';

  @override
  String get tab2Title => 'Alerts';

  @override
  String get tab3Title => 'Recommendations';

  @override
  String get statisticsRecentSamples => 'Recent Samples';

  @override
  String alertsActiveCount(int count) {
    return '$count active alerts';
  }

  @override
  String get alertsNoAlerts => 'All clear — no active alerts';

  @override
  String get recommendationsNoItems => 'No recommendations right now';

  @override
  String get recommendationsMarkApplied => 'Mark Applied';

  @override
  String get recommendationsApplied => 'Applied';

  @override
  String get recommendationsPriorityHigh => 'High';

  @override
  String get recommendationsPriorityMedium => 'Medium';

  @override
  String get recommendationsPriorityLow => 'Low';

  @override
  String get menuPageTitle => 'Menu';

  @override
  String get menuPageChangeAccount => 'Change Account';

  @override
  String get menuPageContracts => 'Contracts';

  @override
  String get menuPagePayments => 'Payments';

  @override
  String get menuPageClaims => 'Claims';

  @override
  String get menuPageConditionAndTerms => 'Terms & Conditions';

  @override
  String get menuPageSecurityPolicy => 'Security Policy';

  @override
  String get menuPageOfferPage => 'Offers';

  @override
  String get menuPageFAQ => 'FAQ';

  @override
  String get menuPageFAQLife => 'FAQ Life';

  @override
  String get menuPageChatBot => 'Chat Bot';

  @override
  String get menuPageContactUs => 'Contact Us';

  @override
  String get menuPageRemoveAccount => 'Delete Account';

  @override
  String get menuPageWarning => 'Warning';

  @override
  String get menuPageDeleteAccount =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get menuPageAcceptDelete => 'Delete';

  @override
  String get menuPageRejectDelete => 'Cancel';

  @override
  String get menuSettingsTitle => 'Settings';

  @override
  String get menuCardAccountTitle => 'Account';

  @override
  String get menuCardAccountSubtitle =>
      'Profile, sign-in, and linked accounts.';

  @override
  String get menuCardMonitoringTitle => 'Monitoring';

  @override
  String get menuCardMonitoringSubtitle =>
      'Statistics, soil alerts, and recommendations.';

  @override
  String get menuCardLegalTitle => 'Legal';

  @override
  String get menuCardLegalSubtitle => 'Terms of use and security policy.';

  @override
  String get menuCardSupportTitle => 'Support';

  @override
  String get menuCardSupportSubtitle => 'FAQ and ways to reach us.';

  @override
  String get menuCardPreferencesTitle => 'Preferences';

  @override
  String get menuCardPreferencesSubtitle => 'Language and regional options.';

  @override
  String get menuCardSessionTitle => 'Session';

  @override
  String get menuCardSessionSubtitle =>
      'Sign out or remove this account from the device.';

  @override
  String get offerPageTitle => 'Offers & Feedback';

  @override
  String get offerPageGeneral => 'General';

  @override
  String get offerPageMedical => 'Medical';

  @override
  String get offerPageSuggestion => 'Suggestion';

  @override
  String get offerPageComplaint => 'Complaint';

  @override
  String get offerPageComments => 'Write your comments here...';

  @override
  String get offerPageSubmit => 'Submit';

  @override
  String get offerPageCommentError =>
      'Please enter your comments before submitting.';

  @override
  String get offerPageCancelErrorMessage =>
      'Something went wrong. Please try again.';

  @override
  String get offerPageSuccessMessage =>
      'Your feedback has been submitted successfully!';

  @override
  String get userAgreementTitle => 'Terms & Conditions';

  @override
  String get userAgreementAddress => '123 Example Street, Baku, Azerbaijan';

  @override
  String get userAgreementTelephone => 'Tel: +994 12 000 00 00';

  @override
  String get userAgreementEmail => 'Email: info@example.com';

  @override
  String get userAgreementWebsite => 'Website: example.com';

  @override
  String get userAgreementLicense => 'License: #000000';

  @override
  String get userAgreementSubtitle => 'Terms of Service';

  @override
  String get userAgreementSubtext1 =>
      'These Terms of Service govern your use of the application.';

  @override
  String get userAgreementSubtext2 =>
      'By using the app, you agree to these terms.';

  @override
  String get userAgreementSubtext3 =>
      'We reserve the right to update these terms at any time.';

  @override
  String get userAgreementSubtext4 =>
      'Continued use after changes constitutes acceptance.';

  @override
  String get userAgreementConceptTitle => 'Key Definitions';

  @override
  String get userAgreementConceptSubtitle1 =>
      '\"Service\" refers to the Soil Report mobile application.';

  @override
  String get userAgreementConceptSubtitle2 =>
      '\"User\" refers to any person who downloads and uses the app.';

  @override
  String get userAgreementConceptSubtitle3 =>
      '\"Content\" means data, text, and information provided through the app.';

  @override
  String get userAgreementConceptSubtitle4 =>
      '\"Personal Data\" means any information that identifies a user.';

  @override
  String get userAgreementConceptSubtitle5 =>
      '\"Account\" means a registered user profile in the app.';

  @override
  String get userAgreementConceptSubtitle6 =>
      '\"Provider\" refers to the entity operating this service.';

  @override
  String get userAgreementConceptSubtitle7 =>
      '\"Third Party\" means any external service or entity.';

  @override
  String get userAgreementConceptSubtitle8 =>
      '\"Device\" means any electronic device used to access the service.';

  @override
  String get userAgreementConceptSubtitle9 =>
      '\"Update\" means any modification to the app or its terms.';

  @override
  String get userAgreementGeneralInformationTitle => 'General Information';

  @override
  String get userAgreementGeneralInformationSubtitle =>
      'The following general rules apply:';

  @override
  String get userAgreementGeneralInformationOption1 =>
      'Users must provide accurate information during registration.';

  @override
  String get userAgreementGeneralInformationOption2 =>
      'Users are responsible for maintaining account security.';

  @override
  String get userAgreementGeneralInformationOption3 =>
      'Misuse of the service may result in account termination.';

  @override
  String get privacyPolicySubtitle => 'Privacy Policy';

  @override
  String get privacyPolicySubtext =>
      'This Privacy Policy explains how we collect, use, and protect your personal data.';

  @override
  String get privacyPolicyConceptTitle => 'Data Collection';

  @override
  String get privacyPolicyConceptSubtitle =>
      'We collect the following types of data:';

  @override
  String get privacyPolicyConceptSubtitle1 =>
      'Personal identification information (name, email, phone number).';

  @override
  String get privacyPolicyConceptSubtitle2 =>
      'Device information (model, OS version).';

  @override
  String get privacyPolicyConceptSubtitle3 =>
      'Location data (when granted permission).';

  @override
  String get privacyPolicyConceptSubtitle4 =>
      'Usage analytics and crash reports.';

  @override
  String get privacyPolicyConceptSubtitle5 =>
      'Soil sample data and field information.';

  @override
  String get privacyPolicyConceptSubtitle6 =>
      'Communication preferences and feedback.';

  @override
  String get privacyPolicyObligationTitle => 'Our Obligations';

  @override
  String get privacyPolicyObligationSubtitle1 =>
      'We will protect your data using industry-standard security measures.';

  @override
  String get privacyPolicyObligationSubtitle2 =>
      'We will not sell your personal data to third parties.';

  @override
  String get privacyPolicyObligationSubtitle3 =>
      'You can request data deletion at any time by contacting support.';

  @override
  String get profilePageTitle => 'Profile';

  @override
  String get profilePageName => 'Full Name';

  @override
  String get profilePageEmail => 'Email';

  @override
  String get profilePagePhoneNumber => 'Phone Number';

  @override
  String get profilePageEnterEmail => 'Enter your email';

  @override
  String get profilePageEnterPhoneNumber => 'Enter your phone number';

  @override
  String get notificationPageHeader => 'Notifications';

  @override
  String get notificationMarkAllAsRead => 'Mark All as Read';

  @override
  String get notificationDeleteAllMessage => 'Delete All';

  @override
  String get notificationSwipeDelete => 'Delete';

  @override
  String get notificationDetailClose => 'Close';

  @override
  String get notificationThereIsNoNotification => 'No notifications yet';

  @override
  String get notificationsLoading => 'Loading notifications...';

  @override
  String get notificationsError => 'Failed to load notifications';

  @override
  String notificationUnreadCount(int count) {
    return '$count unread Notifications';
  }

  @override
  String get changeProfilePageTitle => 'Linked Accounts';

  @override
  String get changeProfilePageEmpty => 'No linked accounts found.';

  @override
  String get changeProfilePageAddNewAccountButton => 'Add New Account';

  @override
  String get deletePopupSuccessTitle => 'Success';

  @override
  String get deletePopupAccountRemoved => 'Account has been removed.';

  @override
  String get deletePopupConfirmTitle => 'Confirm Deletion';

  @override
  String get deletePopupRemoveAccountMessage =>
      'Are you sure you want to remove this account?';

  @override
  String get deletePopupRemoveAccountAddedMeMessage =>
      'This account was linked by another user. Remove the link?';

  @override
  String get linkedAccountOtpPageVerifyButton => 'Verify';

  @override
  String get linkedAccountOtpPagePhoneNumberSent => 'Verification code sent to';

  @override
  String get linkedAccountOtpPageEnterSixDigitCode => 'Enter the 6-digit code';

  @override
  String get linkedAccountSuccessPageTitle => 'Account Linked!';

  @override
  String get linkedAccountSuccessPageSubtitle =>
      'The account has been successfully linked to your profile.';

  @override
  String get linkedAccountSuccessPageDoneButton => 'Done';

  @override
  String get storyPageSeeMore => 'See more';

  @override
  String get sosMedical => 'Medical';

  @override
  String get sosTransport => 'Transport';

  @override
  String get sosTravel => 'Travel';

  @override
  String get sosProperty => 'Property';

  @override
  String get sosCallCenter => 'Call Center';
}
