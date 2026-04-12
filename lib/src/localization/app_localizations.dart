import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_az.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('az'),
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Report'**
  String get appTitle;

  /// No description provided for @commonSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get commonSignIn;

  /// No description provided for @commonPin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get commonPin;

  /// No description provided for @commonPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get commonPassword;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get commonLanguage;

  /// No description provided for @commonLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get commonLogout;

  /// No description provided for @commonAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Report'**
  String get commonAppTitle;

  /// No description provided for @authAlertNetworkError.
  ///
  /// In en, this message translates to:
  /// **'No network connection. Please check your internet and try again.'**
  String get authAlertNetworkError;

  /// No description provided for @authAlertInternalNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach the server. Please try again later.'**
  String get authAlertInternalNetworkError;

  /// No description provided for @authAlertUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get authAlertUnknown;

  /// No description provided for @authAlertHasConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection restored. Proceeding...'**
  String get authAlertHasConnection;

  /// No description provided for @authRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get authRetry;

  /// No description provided for @authProceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get authProceed;

  /// No description provided for @splashPlantCaption.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Soil Report'**
  String get splashPlantCaption;

  /// No description provided for @splashPlantMessage.
  ///
  /// In en, this message translates to:
  /// **'Monitor your soil health, track samples, and receive actionable recommendations — all in one place.'**
  String get splashPlantMessage;

  /// No description provided for @splashMonitorCaption.
  ///
  /// In en, this message translates to:
  /// **'Field Analysis'**
  String get splashMonitorCaption;

  /// No description provided for @splashMonitorMessage.
  ///
  /// In en, this message translates to:
  /// **'Collect and track soil samples across all your field sites with GPS precision.'**
  String get splashMonitorMessage;

  /// No description provided for @splashHarvestCaption.
  ///
  /// In en, this message translates to:
  /// **'Site Monitoring'**
  String get splashHarvestCaption;

  /// No description provided for @splashHarvestMessage.
  ///
  /// In en, this message translates to:
  /// **'Keep an eye on pH, moisture, nutrients, and organic matter for every plot you manage.'**
  String get splashHarvestMessage;

  /// No description provided for @splashDataCaption.
  ///
  /// In en, this message translates to:
  /// **'Smart Recommendations'**
  String get splashDataCaption;

  /// No description provided for @splashDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Get AI-driven suggestions for fertilization, irrigation, and soil amendments tailored to your fields.'**
  String get splashDataMessage;

  /// No description provided for @landingPageNewUser.
  ///
  /// In en, this message translates to:
  /// **'New user?'**
  String get landingPageNewUser;

  /// No description provided for @landingPageCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get landingPageCreateAccount;

  /// No description provided for @pinPageEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get pinPageEnterPin;

  /// No description provided for @pinPageEntryPin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pinPageEntryPin;

  /// No description provided for @pinPageAcceptTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'By signing in you accept the Terms & Conditions'**
  String get pinPageAcceptTermsAndConditions;

  /// No description provided for @passCodePageFingerPrintHeader.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics to sign in'**
  String get passCodePageFingerPrintHeader;

  /// No description provided for @loginPageForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginPageForgotPassword;

  /// No description provided for @loginPageRenewPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get loginPageRenewPassword;

  /// No description provided for @phoneNumberPageEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneNumberPageEnterPhoneNumber;

  /// No description provided for @phoneVerifyPageOtpCodeSent.
  ///
  /// In en, this message translates to:
  /// **'A verification code has been sent to your phone.'**
  String get phoneVerifyPageOtpCodeSent;

  /// No description provided for @phoneVerifyPageEnterOptCode.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get phoneVerifyPageEnterOptCode;

  /// No description provided for @phoneVerifyPageSmsTimerInfo.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive a code? Resend in'**
  String get phoneVerifyPageSmsTimerInfo;

  /// No description provided for @phoneVerifyPageResendSms.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get phoneVerifyPageResendSms;

  /// No description provided for @resetPasswordPageRepeatPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get resetPasswordPageRepeatPassword;

  /// No description provided for @resetPasswordPageConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get resetPasswordPageConfirmNewPassword;

  /// No description provided for @resetPasswordPageConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get resetPasswordPageConfirmPassword;

  /// No description provided for @dashboardPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get dashboardPageTitle;

  /// No description provided for @dashboardPageHi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get dashboardPageHi;

  /// No description provided for @dashboardPageWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get dashboardPageWelcome;

  /// No description provided for @dashboardPagePeriodCount.
  ///
  /// In en, this message translates to:
  /// **'Periods'**
  String get dashboardPagePeriodCount;

  /// No description provided for @dashboardPagePolicies.
  ///
  /// In en, this message translates to:
  /// **'Policies'**
  String get dashboardPagePolicies;

  /// No description provided for @dashboardPageNoClaimsDaysCount.
  ///
  /// In en, this message translates to:
  /// **'No-claims days'**
  String get dashboardPageNoClaimsDaysCount;

  /// No description provided for @dashboardPagePendingSignCount.
  ///
  /// In en, this message translates to:
  /// **'pending documents'**
  String get dashboardPagePendingSignCount;

  /// No description provided for @dashboardPageUrgentSignFile.
  ///
  /// In en, this message translates to:
  /// **'Urgent: Sign required'**
  String get dashboardPageUrgentSignFile;

  /// No description provided for @dashboardPageViewAllSignDocs.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get dashboardPageViewAllSignDocs;

  /// No description provided for @tab1Title.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get tab1Title;

  /// No description provided for @tab2Title.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get tab2Title;

  /// No description provided for @tab3Title.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get tab3Title;

  /// No description provided for @statisticsRecentSamples.
  ///
  /// In en, this message translates to:
  /// **'Recent Samples'**
  String get statisticsRecentSamples;

  /// No description provided for @alertsActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active alerts'**
  String alertsActiveCount(int count);

  /// No description provided for @alertsNoAlerts.
  ///
  /// In en, this message translates to:
  /// **'All clear — no active alerts'**
  String get alertsNoAlerts;

  /// No description provided for @recommendationsNoItems.
  ///
  /// In en, this message translates to:
  /// **'No recommendations right now'**
  String get recommendationsNoItems;

  /// No description provided for @recommendationsMarkApplied.
  ///
  /// In en, this message translates to:
  /// **'Mark Applied'**
  String get recommendationsMarkApplied;

  /// No description provided for @recommendationsApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get recommendationsApplied;

  /// No description provided for @recommendationsPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get recommendationsPriorityHigh;

  /// No description provided for @recommendationsPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get recommendationsPriorityMedium;

  /// No description provided for @recommendationsPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get recommendationsPriorityLow;

  /// No description provided for @menuPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuPageTitle;

  /// No description provided for @menuPageChangeAccount.
  ///
  /// In en, this message translates to:
  /// **'Change Account'**
  String get menuPageChangeAccount;

  /// No description provided for @menuPageContracts.
  ///
  /// In en, this message translates to:
  /// **'Contracts'**
  String get menuPageContracts;

  /// No description provided for @menuPagePayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get menuPagePayments;

  /// No description provided for @menuPageClaims.
  ///
  /// In en, this message translates to:
  /// **'Claims'**
  String get menuPageClaims;

  /// No description provided for @menuPageConditionAndTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get menuPageConditionAndTerms;

  /// No description provided for @menuPageSecurityPolicy.
  ///
  /// In en, this message translates to:
  /// **'Security Policy'**
  String get menuPageSecurityPolicy;

  /// No description provided for @menuPageOfferPage.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get menuPageOfferPage;

  /// No description provided for @menuPageFAQ.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get menuPageFAQ;

  /// No description provided for @menuPageFAQLife.
  ///
  /// In en, this message translates to:
  /// **'FAQ Life'**
  String get menuPageFAQLife;

  /// No description provided for @menuPageChatBot.
  ///
  /// In en, this message translates to:
  /// **'Chat Bot'**
  String get menuPageChatBot;

  /// No description provided for @menuPageContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get menuPageContactUs;

  /// No description provided for @menuPageRemoveAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get menuPageRemoveAccount;

  /// No description provided for @menuPageWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get menuPageWarning;

  /// No description provided for @menuPageDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get menuPageDeleteAccount;

  /// No description provided for @menuPageAcceptDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get menuPageAcceptDelete;

  /// No description provided for @menuPageRejectDelete.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get menuPageRejectDelete;

  /// No description provided for @menuSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettingsTitle;

  /// No description provided for @menuCardAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get menuCardAccountTitle;

  /// No description provided for @menuCardAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profile, sign-in, and linked accounts.'**
  String get menuCardAccountSubtitle;

  /// No description provided for @menuCardMonitoringTitle.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get menuCardMonitoringTitle;

  /// No description provided for @menuCardMonitoringSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics, soil alerts, and recommendations.'**
  String get menuCardMonitoringSubtitle;

  /// No description provided for @menuCardLegalTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get menuCardLegalTitle;

  /// No description provided for @menuCardLegalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of use and security policy.'**
  String get menuCardLegalSubtitle;

  /// No description provided for @menuCardSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get menuCardSupportTitle;

  /// No description provided for @menuCardSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ and ways to reach us.'**
  String get menuCardSupportSubtitle;

  /// No description provided for @menuCardPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get menuCardPreferencesTitle;

  /// No description provided for @menuCardPreferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Language and regional options.'**
  String get menuCardPreferencesSubtitle;

  /// No description provided for @menuCardSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get menuCardSessionTitle;

  /// No description provided for @menuCardSessionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out or remove this account from the device.'**
  String get menuCardSessionSubtitle;

  /// No description provided for @offerPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers & Feedback'**
  String get offerPageTitle;

  /// No description provided for @offerPageGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get offerPageGeneral;

  /// No description provided for @offerPageMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get offerPageMedical;

  /// No description provided for @offerPageSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get offerPageSuggestion;

  /// No description provided for @offerPageComplaint.
  ///
  /// In en, this message translates to:
  /// **'Complaint'**
  String get offerPageComplaint;

  /// No description provided for @offerPageComments.
  ///
  /// In en, this message translates to:
  /// **'Write your comments here...'**
  String get offerPageComments;

  /// No description provided for @offerPageSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get offerPageSubmit;

  /// No description provided for @offerPageCommentError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your comments before submitting.'**
  String get offerPageCommentError;

  /// No description provided for @offerPageCancelErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get offerPageCancelErrorMessage;

  /// No description provided for @offerPageSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your feedback has been submitted successfully!'**
  String get offerPageSuccessMessage;

  /// No description provided for @userAgreementTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get userAgreementTitle;

  /// No description provided for @userAgreementAddress.
  ///
  /// In en, this message translates to:
  /// **'123 Example Street, Baku, Azerbaijan'**
  String get userAgreementAddress;

  /// No description provided for @userAgreementTelephone.
  ///
  /// In en, this message translates to:
  /// **'Tel: +994 12 000 00 00'**
  String get userAgreementTelephone;

  /// No description provided for @userAgreementEmail.
  ///
  /// In en, this message translates to:
  /// **'Email: info@example.com'**
  String get userAgreementEmail;

  /// No description provided for @userAgreementWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website: example.com'**
  String get userAgreementWebsite;

  /// No description provided for @userAgreementLicense.
  ///
  /// In en, this message translates to:
  /// **'License: #000000'**
  String get userAgreementLicense;

  /// No description provided for @userAgreementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get userAgreementSubtitle;

  /// No description provided for @userAgreementSubtext1.
  ///
  /// In en, this message translates to:
  /// **'These Terms of Service govern your use of the application.'**
  String get userAgreementSubtext1;

  /// No description provided for @userAgreementSubtext2.
  ///
  /// In en, this message translates to:
  /// **'By using the app, you agree to these terms.'**
  String get userAgreementSubtext2;

  /// No description provided for @userAgreementSubtext3.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to update these terms at any time.'**
  String get userAgreementSubtext3;

  /// No description provided for @userAgreementSubtext4.
  ///
  /// In en, this message translates to:
  /// **'Continued use after changes constitutes acceptance.'**
  String get userAgreementSubtext4;

  /// No description provided for @userAgreementConceptTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Definitions'**
  String get userAgreementConceptTitle;

  /// No description provided for @userAgreementConceptSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'\"Service\" refers to the Soil Report mobile application.'**
  String get userAgreementConceptSubtitle1;

  /// No description provided for @userAgreementConceptSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'\"User\" refers to any person who downloads and uses the app.'**
  String get userAgreementConceptSubtitle2;

  /// No description provided for @userAgreementConceptSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'\"Content\" means data, text, and information provided through the app.'**
  String get userAgreementConceptSubtitle3;

  /// No description provided for @userAgreementConceptSubtitle4.
  ///
  /// In en, this message translates to:
  /// **'\"Personal Data\" means any information that identifies a user.'**
  String get userAgreementConceptSubtitle4;

  /// No description provided for @userAgreementConceptSubtitle5.
  ///
  /// In en, this message translates to:
  /// **'\"Account\" means a registered user profile in the app.'**
  String get userAgreementConceptSubtitle5;

  /// No description provided for @userAgreementConceptSubtitle6.
  ///
  /// In en, this message translates to:
  /// **'\"Provider\" refers to the entity operating this service.'**
  String get userAgreementConceptSubtitle6;

  /// No description provided for @userAgreementConceptSubtitle7.
  ///
  /// In en, this message translates to:
  /// **'\"Third Party\" means any external service or entity.'**
  String get userAgreementConceptSubtitle7;

  /// No description provided for @userAgreementConceptSubtitle8.
  ///
  /// In en, this message translates to:
  /// **'\"Device\" means any electronic device used to access the service.'**
  String get userAgreementConceptSubtitle8;

  /// No description provided for @userAgreementConceptSubtitle9.
  ///
  /// In en, this message translates to:
  /// **'\"Update\" means any modification to the app or its terms.'**
  String get userAgreementConceptSubtitle9;

  /// No description provided for @userAgreementGeneralInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get userAgreementGeneralInformationTitle;

  /// No description provided for @userAgreementGeneralInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The following general rules apply:'**
  String get userAgreementGeneralInformationSubtitle;

  /// No description provided for @userAgreementGeneralInformationOption1.
  ///
  /// In en, this message translates to:
  /// **'Users must provide accurate information during registration.'**
  String get userAgreementGeneralInformationOption1;

  /// No description provided for @userAgreementGeneralInformationOption2.
  ///
  /// In en, this message translates to:
  /// **'Users are responsible for maintaining account security.'**
  String get userAgreementGeneralInformationOption2;

  /// No description provided for @userAgreementGeneralInformationOption3.
  ///
  /// In en, this message translates to:
  /// **'Misuse of the service may result in account termination.'**
  String get userAgreementGeneralInformationOption3;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicySubtitle;

  /// No description provided for @privacyPolicySubtext.
  ///
  /// In en, this message translates to:
  /// **'This Privacy Policy explains how we collect, use, and protect your personal data.'**
  String get privacyPolicySubtext;

  /// No description provided for @privacyPolicyConceptTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get privacyPolicyConceptTitle;

  /// No description provided for @privacyPolicyConceptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We collect the following types of data:'**
  String get privacyPolicyConceptSubtitle;

  /// No description provided for @privacyPolicyConceptSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Personal identification information (name, email, phone number).'**
  String get privacyPolicyConceptSubtitle1;

  /// No description provided for @privacyPolicyConceptSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Device information (model, OS version).'**
  String get privacyPolicyConceptSubtitle2;

  /// No description provided for @privacyPolicyConceptSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Location data (when granted permission).'**
  String get privacyPolicyConceptSubtitle3;

  /// No description provided for @privacyPolicyConceptSubtitle4.
  ///
  /// In en, this message translates to:
  /// **'Usage analytics and crash reports.'**
  String get privacyPolicyConceptSubtitle4;

  /// No description provided for @privacyPolicyConceptSubtitle5.
  ///
  /// In en, this message translates to:
  /// **'Soil sample data and field information.'**
  String get privacyPolicyConceptSubtitle5;

  /// No description provided for @privacyPolicyConceptSubtitle6.
  ///
  /// In en, this message translates to:
  /// **'Communication preferences and feedback.'**
  String get privacyPolicyConceptSubtitle6;

  /// No description provided for @privacyPolicyObligationTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Obligations'**
  String get privacyPolicyObligationTitle;

  /// No description provided for @privacyPolicyObligationSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'We will protect your data using industry-standard security measures.'**
  String get privacyPolicyObligationSubtitle1;

  /// No description provided for @privacyPolicyObligationSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'We will not sell your personal data to third parties.'**
  String get privacyPolicyObligationSubtitle2;

  /// No description provided for @privacyPolicyObligationSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'You can request data deletion at any time by contacting support.'**
  String get privacyPolicyObligationSubtitle3;

  /// No description provided for @profilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profilePageTitle;

  /// No description provided for @profilePageName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profilePageName;

  /// No description provided for @profilePageEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profilePageEmail;

  /// No description provided for @profilePagePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profilePagePhoneNumber;

  /// No description provided for @profilePageEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get profilePageEnterEmail;

  /// No description provided for @profilePageEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get profilePageEnterPhoneNumber;

  /// No description provided for @notificationPageHeader.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationPageHeader;

  /// No description provided for @notificationMarkAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get notificationMarkAllAsRead;

  /// No description provided for @notificationDeleteAllMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get notificationDeleteAllMessage;

  /// No description provided for @notificationSwipeDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get notificationSwipeDelete;

  /// No description provided for @notificationDetailClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get notificationDetailClose;

  /// No description provided for @notificationThereIsNoNotification.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationThereIsNoNotification;

  /// No description provided for @notificationsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading notifications...'**
  String get notificationsLoading;

  /// No description provided for @notificationsError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get notificationsError;

  /// No description provided for @notificationUnreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unread Notifications'**
  String notificationUnreadCount(int count);

  /// No description provided for @changeProfilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Linked Accounts'**
  String get changeProfilePageTitle;

  /// No description provided for @changeProfilePageEmpty.
  ///
  /// In en, this message translates to:
  /// **'No linked accounts found.'**
  String get changeProfilePageEmpty;

  /// No description provided for @changeProfilePageAddNewAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Add New Account'**
  String get changeProfilePageAddNewAccountButton;

  /// No description provided for @deletePopupSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get deletePopupSuccessTitle;

  /// No description provided for @deletePopupAccountRemoved.
  ///
  /// In en, this message translates to:
  /// **'Account has been removed.'**
  String get deletePopupAccountRemoved;

  /// No description provided for @deletePopupConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get deletePopupConfirmTitle;

  /// No description provided for @deletePopupRemoveAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this account?'**
  String get deletePopupRemoveAccountMessage;

  /// No description provided for @deletePopupRemoveAccountAddedMeMessage.
  ///
  /// In en, this message translates to:
  /// **'This account was linked by another user. Remove the link?'**
  String get deletePopupRemoveAccountAddedMeMessage;

  /// No description provided for @linkedAccountOtpPageVerifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get linkedAccountOtpPageVerifyButton;

  /// No description provided for @linkedAccountOtpPagePhoneNumberSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to'**
  String get linkedAccountOtpPagePhoneNumberSent;

  /// No description provided for @linkedAccountOtpPageEnterSixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get linkedAccountOtpPageEnterSixDigitCode;

  /// No description provided for @linkedAccountSuccessPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Linked!'**
  String get linkedAccountSuccessPageTitle;

  /// No description provided for @linkedAccountSuccessPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The account has been successfully linked to your profile.'**
  String get linkedAccountSuccessPageSubtitle;

  /// No description provided for @linkedAccountSuccessPageDoneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get linkedAccountSuccessPageDoneButton;

  /// No description provided for @storyPageSeeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get storyPageSeeMore;

  /// No description provided for @sosMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get sosMedical;

  /// No description provided for @sosTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get sosTransport;

  /// No description provided for @sosTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get sosTravel;

  /// No description provided for @sosProperty.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get sosProperty;

  /// No description provided for @sosCallCenter.
  ///
  /// In en, this message translates to:
  /// **'Call Center'**
  String get sosCallCenter;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['az', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'az':
      return AppLocalizationsAz();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
