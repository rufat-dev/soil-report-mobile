import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

extension LocalizationExtension on String {
  /// Legacy bridge: maps old "DotCase.Key" translation keys to generated AppLocalizations getters.
  /// Returns the localized string when a mapping exists, otherwise returns `this` as-is.
  String translate(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _keyMap[this]?.call(l10n) ?? this;
  }
}

typedef _L10nGetter = String Function(AppLocalizations l10n);

final Map<String, _L10nGetter> _keyMap = {
  // Common
  'Common.SignIn': (l) => l.commonSignIn,
  'Common.Pin': (l) => l.commonPin,
  'Common.Password': (l) => l.commonPassword,
  'Common.Next': (l) => l.commonNext,
  'Common.Close': (l) => l.commonClose,
  'Common.Yes': (l) => l.commonYes,
  'Common.No': (l) => l.commonNo,
  'Common.Language': (l) => l.commonLanguage,
  'Common.Logout': (l) => l.commonLogout,
  'Common.SoilplantTitle': (l) => l.commonAppTitle,

  // Auth Alert
  'Auth.Alert.NetworkError': (l) => l.authAlertNetworkError,
  'Auth.Alert.InternalNetworkError': (l) => l.authAlertInternalNetworkError,
  'Auth.Alert.Unknown': (l) => l.authAlertUnknown,
  'Auth.Alert.HasConnection': (l) => l.authAlertHasConnection,
  'Auth.Retry': (l) => l.authRetry,
  'Auth.Proceed': (l) => l.authProceed,

  // Splash / Landing carousel
  'Splash.PlantCaption': (l) => l.splashPlantCaption,
  'Splash.PlantMessage': (l) => l.splashPlantMessage,
  'Splash.MonitorCaption': (l) => l.splashMonitorCaption,
  'Splash.MonitorMessage': (l) => l.splashMonitorMessage,
  'Splash.HarvestCaption': (l) => l.splashHarvestCaption,
  'Splash.HarvestMessage': (l) => l.splashHarvestMessage,
  'Splash.DataCaption': (l) => l.splashDataCaption,
  'Splash.DataMessage': (l) => l.splashDataMessage,

  // Landing
  'LandingPage.NewUser': (l) => l.landingPageNewUser,
  'LandingPage.CreateAccount': (l) => l.landingPageCreateAccount,

  // PIN
  'PinPage.EnterPin': (l) => l.pinPageEnterPin,
  'PinPage.EntryPin': (l) => l.pinPageEntryPin,
  'PinPage.AcceptTermsAndConditions': (l) => l.pinPageAcceptTermsAndConditions,

  // Passcode
  'PassCodePage.FingerPrint.Header': (l) => l.passCodePageFingerPrintHeader,

  // Login
  'LoginPage.ForgotPassword': (l) => l.loginPageForgotPassword,
  'LoginPage.RenewPassword': (l) => l.loginPageRenewPassword,

  // Phone Number
  'PhoneNumberPage.EnterPhoneNumber': (l) => l.phoneNumberPageEnterPhoneNumber,

  // Phone Verify
  'PhoneVerifyPage.OtpCodeSent': (l) => l.phoneVerifyPageOtpCodeSent,
  'PhoneVerifyPage.EnterOptCode': (l) => l.phoneVerifyPageEnterOptCode,
  'PhoneVerifyPage.SmsTimerInfo': (l) => l.phoneVerifyPageSmsTimerInfo,
  'PhoneVerifyPage.ResendSms': (l) => l.phoneVerifyPageResendSms,

  // Reset Password
  'ResetPasswordPage.RepeatPassword': (l) => l.resetPasswordPageRepeatPassword,
  'ResetPasswordPage.ConfirmNewPassword': (l) => l.resetPasswordPageConfirmNewPassword,
  'ResetPasswordPage.ConfirmPassword': (l) => l.resetPasswordPageConfirmPassword,

  // Dashboard
  'DashboardPage.Title': (l) => l.dashboardPageTitle,
  'DashboardPage.Hi': (l) => l.dashboardPageHi,
  'DashboardPage.Welcome': (l) => l.dashboardPageWelcome,
  'DashboardPage.PeriodCount': (l) => l.dashboardPagePeriodCount,
  'DashboardPage.Policies': (l) => l.dashboardPagePolicies,
  'DashboardPage.NoClaimsDaysCount': (l) => l.dashboardPageNoClaimsDaysCount,
  'DashboardPage.PendingSignCount': (l) => l.dashboardPagePendingSignCount,
  'DashboardPage.UrgentSignFile': (l) => l.dashboardPageUrgentSignFile,
  'DashboardPage.ViewAllSignDocs': (l) => l.dashboardPageViewAllSignDocs,

  // Tabs
  'Tab1.Title': (l) => l.tab1Title,
  'Tab2.Title': (l) => l.tab2Title,
  'Tab3.Title': (l) => l.tab3Title,
  'PoliciesPage.Title': (l) => l.tab1Title,
  'PaymentsPage.Title': (l) => l.tab2Title,
  'ClaimsPage.Title': (l) => l.tab3Title,

  // Menu
  'MenuPage.Title': (l) => l.menuPageTitle,
  'MenuPage.ChangeAccount': (l) => l.menuPageChangeAccount,
  'MenuPage.Contracts': (l) => l.menuPageContracts,
  'MenuPage.Payments': (l) => l.menuPagePayments,
  'MenuPage.Claims': (l) => l.menuPageClaims,
  'MenuPage.ConditionAndTerms': (l) => l.menuPageConditionAndTerms,
  'MenuPage.SecurityPolicy': (l) => l.menuPageSecurityPolicy,
  'MenuPage.OfferPage': (l) => l.menuPageOfferPage,
  'MenuPage.FAQ': (l) => l.menuPageFAQ,
  'MenuPage.FAQLife': (l) => l.menuPageFAQLife,
  'MenuPage.ChatBot': (l) => l.menuPageChatBot,
  'MenuPage.ContactUs': (l) => l.menuPageContactUs,
  'MenuPage.RemoveAccount': (l) => l.menuPageRemoveAccount,
  'MenuPage.Warning': (l) => l.menuPageWarning,
  'MenuPage.DeleteAccount': (l) => l.menuPageDeleteAccount,
  'MenuPage.AcceptDelete': (l) => l.menuPageAcceptDelete,
  'MenuPage.RejectDelete': (l) => l.menuPageRejectDelete,

  // Offers
  'OfferPage.Title': (l) => l.offerPageTitle,
  'OfferPage.Soilplant': (l) => l.offerPageGeneral,
  'OfferPage.Medical': (l) => l.offerPageMedical,
  'OfferPage.Suggestion': (l) => l.offerPageSuggestion,
  'OfferPage.Complaint': (l) => l.offerPageComplaint,
  'OfferPage.Comments': (l) => l.offerPageComments,
  'OfferPage.Submit': (l) => l.offerPageSubmit,
  'OfferPage.CommentError': (l) => l.offerPageCommentError,
  'OfferPage.CancelErrorMessage': (l) => l.offerPageCancelErrorMessage,
  'OfferPage.SuccessMessage': (l) => l.offerPageSuccessMessage,

  // User Agreement / Conditions
  'UserAgreement.Title': (l) => l.userAgreementTitle,
  'UserAgreement.Address': (l) => l.userAgreementAddress,
  'UserAgreement.Telephone': (l) => l.userAgreementTelephone,
  'UserAgreement.Email': (l) => l.userAgreementEmail,
  'UserAgreement.Website': (l) => l.userAgreementWebsite,
  'UserAgreement.Lisence': (l) => l.userAgreementLicense,
  'UserAgreement.Subtitle': (l) => l.userAgreementSubtitle,
  'UserAgreement.Subtext1': (l) => l.userAgreementSubtext1,
  'UserAgreement.Subtext2': (l) => l.userAgreementSubtext2,
  'UserAgreement.Subtext3': (l) => l.userAgreementSubtext3,
  'UserAgreement.Subtext4': (l) => l.userAgreementSubtext4,
  'UserAgreement.ConceptTitle': (l) => l.userAgreementConceptTitle,
  'UserAgreement.ConceptSubtitle1': (l) => l.userAgreementConceptSubtitle1,
  'UserAgreement.ConceptSubtitle2': (l) => l.userAgreementConceptSubtitle2,
  'UserAgreement.ConceptSubtitle3': (l) => l.userAgreementConceptSubtitle3,
  'UserAgreement.ConceptSubtitle4': (l) => l.userAgreementConceptSubtitle4,
  'UserAgreement.ConceptSubtitle5': (l) => l.userAgreementConceptSubtitle5,
  'UserAgreement.ConceptSubtitle6': (l) => l.userAgreementConceptSubtitle6,
  'UserAgreement.ConceptSubtitle7': (l) => l.userAgreementConceptSubtitle7,
  'UserAgreement.ConceptSubtitle8': (l) => l.userAgreementConceptSubtitle8,
  'UserAgreement.ConceptSubtitle9': (l) => l.userAgreementConceptSubtitle9,
  'UserAgreement.GeneralInformationTitle': (l) => l.userAgreementGeneralInformationTitle,
  'UserAgreement.GeneralInformationSubtitle': (l) => l.userAgreementGeneralInformationSubtitle,
  'UserAgreement.GeneralInformationOption1': (l) => l.userAgreementGeneralInformationOption1,
  'UserAgreement.GeneralInformationOption2': (l) => l.userAgreementGeneralInformationOption2,
  'UserAgreement.GeneralInformationOption3': (l) => l.userAgreementGeneralInformationOption3,

  // Privacy Policy / Security
  'PrivacyPolicy.Subtitle': (l) => l.privacyPolicySubtitle,
  'PrivacyPolicy.Subtext': (l) => l.privacyPolicySubtext,
  'PrivacyPolicy.ConceptTitle': (l) => l.privacyPolicyConceptTitle,
  'PrivacyPolicy.ConceptSubtitle': (l) => l.privacyPolicyConceptSubtitle,
  'PrivacyPolicy.ConceptSubtitle1': (l) => l.privacyPolicyConceptSubtitle1,
  'PrivacyPolicy.ConceptSubtitle2': (l) => l.privacyPolicyConceptSubtitle2,
  'PrivacyPolicy.ConceptSubtitle3': (l) => l.privacyPolicyConceptSubtitle3,
  'PrivacyPolicy.ConceptSubtitle4': (l) => l.privacyPolicyConceptSubtitle4,
  'PrivacyPolicy.ConceptSubtitle5': (l) => l.privacyPolicyConceptSubtitle5,
  'PrivacyPolicy.ConceptSubtitle6': (l) => l.privacyPolicyConceptSubtitle6,
  'PrivacyPolicy.ObligationTitle': (l) => l.privacyPolicyObligationTitle,
  'PrivacyPolicy.ObligationSubtitle1': (l) => l.privacyPolicyObligationSubtitle1,
  'PrivacyPolicy.ObligationSubtitle2': (l) => l.privacyPolicyObligationSubtitle2,
  'PrivacyPolicy.ObligationSubtitle3': (l) => l.privacyPolicyObligationSubtitle3,

  // Profile
  'ProfilePage.Title': (l) => l.profilePageTitle,
  'ProfilePage.Name': (l) => l.profilePageName,
  'ProfilePage.Email': (l) => l.profilePageEmail,
  'ProfilePage.PhoneNumber': (l) => l.profilePagePhoneNumber,
  'ProfilePage.EnterEmail': (l) => l.profilePageEnterEmail,
  'ProfilePage.EnterPhoneNumber': (l) => l.profilePageEnterPhoneNumber,

  // Notifications
  'NotificationPage.Header': (l) => l.notificationPageHeader,
  'Notification.MarkAllAsRead': (l) => l.notificationMarkAllAsRead,
  'Notification.DeleteAllMessage': (l) => l.notificationDeleteAllMessage,
  'Notification.Swipe.Delete': (l) => l.notificationSwipeDelete,
  'Notification.Detail.Close': (l) => l.notificationDetailClose,
  'Notification.ThereIsNoNotification': (l) => l.notificationThereIsNoNotification,
  'Notifications.Loading': (l) => l.notificationsLoading,
  'Notifications.Error': (l) => l.notificationsError,

  // Change Account / Linked Accounts
  'ChangeProfilePage.Title': (l) => l.changeProfilePageTitle,
  'ChangeProfilePage.Empty': (l) => l.changeProfilePageEmpty,
  'ChangeProfilePage.AddNewAccountButton': (l) => l.changeProfilePageAddNewAccountButton,
  'DeletePopup.SuccessTitle': (l) => l.deletePopupSuccessTitle,
  'DeletePopup.AccountRemoved': (l) => l.deletePopupAccountRemoved,
  'DeletePopup.ConfirmTitle': (l) => l.deletePopupConfirmTitle,
  'DeletePopup.RemoveAccountMessage': (l) => l.deletePopupRemoveAccountMessage,
  'DeletePopup.RemoveAccountAddedMeMessage': (l) => l.deletePopupRemoveAccountAddedMeMessage,

  // Linked Account OTP
  'LinkedAccountOtpPage.VerifyButton': (l) => l.linkedAccountOtpPageVerifyButton,
  'LinkedAccountOtpPage.PhoneNumberSent': (l) => l.linkedAccountOtpPagePhoneNumberSent,
  'LinkedAccountOtpPage.EnterSixDigitCode': (l) => l.linkedAccountOtpPageEnterSixDigitCode,

  // Linked Account Success
  'LinkedAccountSuccessPage.Title': (l) => l.linkedAccountSuccessPageTitle,
  'LinkedAccountSuccessPage.Subtitle': (l) => l.linkedAccountSuccessPageSubtitle,
  'LinkedAccountSuccessPage.DoneButton': (l) => l.linkedAccountSuccessPageDoneButton,

  // Stories
  'StoryPage.SeeMore': (l) => l.storyPageSeeMore,
};
