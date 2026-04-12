// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appTitle => 'Torpaq Hesabatı';

  @override
  String get commonSignIn => 'Daxil ol';

  @override
  String get commonPin => 'PİN';

  @override
  String get commonPassword => 'Şifrə';

  @override
  String get commonNext => 'Növbəti';

  @override
  String get commonClose => 'Bağla';

  @override
  String get commonYes => 'Bəli';

  @override
  String get commonNo => 'Xeyr';

  @override
  String get commonLanguage => 'Dil';

  @override
  String get commonLogout => 'Çıxış';

  @override
  String get commonAppTitle => 'Torpaq Hesabatı';

  @override
  String get authAlertNetworkError =>
      'Şəbəkə bağlantısı yoxdur. İnternetinizi yoxlayın və yenidən cəhd edin.';

  @override
  String get authAlertInternalNetworkError =>
      'Serverə qoşulmaq mümkün deyil. Zəhmət olmasa sonra yenidən cəhd edin.';

  @override
  String get authAlertUnknown =>
      'Gözlənilməz xəta baş verdi. Zəhmət olmasa yenidən cəhd edin.';

  @override
  String get authAlertHasConnection => 'Bağlantı bərpa olundu. Davam edilir...';

  @override
  String get authRetry => 'Yenidən cəhd et';

  @override
  String get authProceed => 'Davam et';

  @override
  String get splashPlantCaption => 'Torpaq Hesabatına xoş gəldiniz';

  @override
  String get splashPlantMessage =>
      'Torpaq sağlamlığını izləyin, nümunələri qeyd edin və fəaliyyətə keçə biləcəyiniz tövsiyələr alın — hamısı bir yerdə.';

  @override
  String get splashMonitorCaption => 'Sahə Analizi';

  @override
  String get splashMonitorMessage =>
      'GPS dəqiqliyi ilə bütün sahə ərazilərinizdə torpaq nümunələrini toplayın və izləyin.';

  @override
  String get splashHarvestCaption => 'Sahə Monitorinqi';

  @override
  String get splashHarvestMessage =>
      'İdarə etdiyiniz hər bir ərazinin pH, rütubət, qida maddələri və üzvi maddələrini izləyin.';

  @override
  String get splashDataCaption => 'Ağıllı Tövsiyələr';

  @override
  String get splashDataMessage =>
      'Sahələrinizə uyğunlaşdırılmış gübrələmə, suvarma və torpaq islahı üçün süni intellekt əsaslı təkliflər alın.';

  @override
  String get landingPageNewUser => 'Yeni istifadəçi?';

  @override
  String get landingPageCreateAccount => 'Hesab yarat';

  @override
  String get pinPageEnterPin => 'PİN kodunuzu daxil edin';

  @override
  String get pinPageEntryPin => 'PİN';

  @override
  String get pinPageAcceptTermsAndConditions =>
      'Daxil olmaqla Şərtlər və Qaydaları qəbul edirsiniz';

  @override
  String get passCodePageFingerPrintHeader =>
      'Daxil olmaq üçün biometriya istifadə edin';

  @override
  String get loginPageForgotPassword => 'Şifrəni unutmusunuz?';

  @override
  String get loginPageRenewPassword => 'Şifrəni sıfırla';

  @override
  String get phoneNumberPageEnterPhoneNumber => 'Telefon nömrənizi daxil edin';

  @override
  String get phoneVerifyPageOtpCodeSent =>
      'Doğrulama kodu telefonunuza göndərildi.';

  @override
  String get phoneVerifyPageEnterOptCode => 'Doğrulama kodunu daxil edin';

  @override
  String get phoneVerifyPageSmsTimerInfo => 'Kod almadınız? Yenidən göndərmə:';

  @override
  String get phoneVerifyPageResendSms => 'Kodu yenidən göndər';

  @override
  String get resetPasswordPageRepeatPassword => 'Yeni şifrə';

  @override
  String get resetPasswordPageConfirmNewPassword => 'Yeni şifrəni təsdiqləyin';

  @override
  String get resetPasswordPageConfirmPassword => 'Təsdiqlə';

  @override
  String get dashboardPageTitle => 'Ana Səhifə';

  @override
  String get dashboardPageHi => 'Salam';

  @override
  String get dashboardPageWelcome => 'Xoş gəldiniz!';

  @override
  String get dashboardPagePeriodCount => 'Müddətlər';

  @override
  String get dashboardPagePolicies => 'Siyasətlər';

  @override
  String get dashboardPageNoClaimsDaysCount => 'İddiasız günlər';

  @override
  String get dashboardPagePendingSignCount => 'gözləyən sənədlər';

  @override
  String get dashboardPageUrgentSignFile => 'Təcili: İmza tələb olunur';

  @override
  String get dashboardPageViewAllSignDocs => 'Hamısına bax';

  @override
  String get tab1Title => 'Statistika';

  @override
  String get tab2Title => 'Xəbərdarlıqlar';

  @override
  String get tab3Title => 'Tövsiyələr';

  @override
  String get statisticsRecentSamples => 'Son nümunələr';

  @override
  String alertsActiveCount(int count) {
    return '$count aktiv xəbərdarlıq';
  }

  @override
  String get alertsNoAlerts =>
      'Hər şey qaydasındadır — aktiv xəbərdarlıq yoxdur';

  @override
  String get recommendationsNoItems => 'Hazırda tövsiyə yoxdur';

  @override
  String get recommendationsMarkApplied => 'Tətbiq et';

  @override
  String get recommendationsApplied => 'Tətbiq edilib';

  @override
  String get recommendationsPriorityHigh => 'Yüksək';

  @override
  String get recommendationsPriorityMedium => 'Orta';

  @override
  String get recommendationsPriorityLow => 'Aşağı';

  @override
  String get menuPageTitle => 'Menyu';

  @override
  String get menuPageChangeAccount => 'Hesab dəyiş';

  @override
  String get menuPageContracts => 'Müqavilələr';

  @override
  String get menuPagePayments => 'Ödənişlər';

  @override
  String get menuPageClaims => 'İddialar';

  @override
  String get menuPageConditionAndTerms => 'Şərtlər və qaydalar';

  @override
  String get menuPageSecurityPolicy => 'Təhlükəsizlik siyasəti';

  @override
  String get menuPageOfferPage => 'Təkliflər';

  @override
  String get menuPageFAQ => 'Sual-Cavab';

  @override
  String get menuPageFAQLife => 'Həyat Sual-Cavab';

  @override
  String get menuPageChatBot => 'Çat Bot';

  @override
  String get menuPageContactUs => 'Bizimlə əlaqə';

  @override
  String get menuPageRemoveAccount => 'Hesabı sil';

  @override
  String get menuPageWarning => 'Xəbərdarlıq';

  @override
  String get menuPageDeleteAccount =>
      'Hesabınızı silmək istədiyinizdən əminsiniz? Bu əməliyyat geri qaytarıla bilməz.';

  @override
  String get menuPageAcceptDelete => 'Sil';

  @override
  String get menuPageRejectDelete => 'Ləğv et';

  @override
  String get menuSettingsTitle => 'Tənzimləmələr';

  @override
  String get menuCardAccountTitle => 'Hesab';

  @override
  String get menuCardAccountSubtitle => 'Profil, daxil olma və bağlı hesablar.';

  @override
  String get menuCardMonitoringTitle => 'Monitorinq';

  @override
  String get menuCardMonitoringSubtitle =>
      'Statistika, torpaq xəbərdarlıqları və tövsiyələr.';

  @override
  String get menuCardLegalTitle => 'Hüquqi';

  @override
  String get menuCardLegalSubtitle =>
      'İstifadə şərtləri və təhlükəsizlik siyasəti.';

  @override
  String get menuCardSupportTitle => 'Dəstək';

  @override
  String get menuCardSupportSubtitle => 'FAQ və əlaqə kanalları.';

  @override
  String get menuCardPreferencesTitle => 'Üstünlüklər';

  @override
  String get menuCardPreferencesSubtitle => 'Dil və regional seçimlər.';

  @override
  String get menuCardSessionTitle => 'Sessiya';

  @override
  String get menuCardSessionSubtitle => 'Çıxış və ya bu cihazdan hesabı silmə.';

  @override
  String get offerPageTitle => 'Təkliflər və Rəy';

  @override
  String get offerPageGeneral => 'Ümumi';

  @override
  String get offerPageMedical => 'Tibbi';

  @override
  String get offerPageSuggestion => 'Təklif';

  @override
  String get offerPageComplaint => 'Şikayət';

  @override
  String get offerPageComments => 'Şərhlərinizi buraya yazın...';

  @override
  String get offerPageSubmit => 'Göndər';

  @override
  String get offerPageCommentError =>
      'Göndərməzdən əvvəl şərhlərinizi daxil edin.';

  @override
  String get offerPageCancelErrorMessage =>
      'Nəsə xəta baş verdi. Yenidən cəhd edin.';

  @override
  String get offerPageSuccessMessage => 'Rəyiniz uğurla göndərildi!';

  @override
  String get userAgreementTitle => 'Şərtlər və qaydalar';

  @override
  String get userAgreementAddress => '123 Nümunə küçəsi, Bakı, Azərbaycan';

  @override
  String get userAgreementTelephone => 'Tel: +994 12 000 00 00';

  @override
  String get userAgreementEmail => 'E-poçt: info@example.com';

  @override
  String get userAgreementWebsite => 'Veb-sayt: example.com';

  @override
  String get userAgreementLicense => 'Lisenziya: #000000';

  @override
  String get userAgreementSubtitle => 'Xidmət şərtləri';

  @override
  String get userAgreementSubtext1 =>
      'Bu Xidmət Şərtləri tətbiqdən istifadənizi tənzimləyir.';

  @override
  String get userAgreementSubtext2 =>
      'Tətbiqdən istifadə etməklə bu şərtləri qəbul edirsiniz.';

  @override
  String get userAgreementSubtext3 =>
      'Bu şərtləri istənilən vaxt yeniləmək hüququmuzu saxlayırıq.';

  @override
  String get userAgreementSubtext4 =>
      'Dəyişikliklərdən sonra istifadənin davam etdirilməsi qəbul sayılır.';

  @override
  String get userAgreementConceptTitle => 'Əsas Anlayışlar';

  @override
  String get userAgreementConceptSubtitle1 =>
      '\"Xidmət\" — Torpaq Hesabatı mobil tətbiqinə aiddir.';

  @override
  String get userAgreementConceptSubtitle2 =>
      '\"İstifadəçi\" — tətbiqi yükləyən və istifadə edən hər bir şəxsə aiddir.';

  @override
  String get userAgreementConceptSubtitle3 =>
      '\"Məzmun\" — tətbiq vasitəsilə təqdim edilən məlumat, mətn və informasiya deməkdir.';

  @override
  String get userAgreementConceptSubtitle4 =>
      '\"Fərdi Məlumat\" — istifadəçini müəyyənləşdirən hər hansı məlumat deməkdir.';

  @override
  String get userAgreementConceptSubtitle5 =>
      '\"Hesab\" — tətbiqdə qeydiyyatdan keçmiş istifadəçi profili deməkdir.';

  @override
  String get userAgreementConceptSubtitle6 =>
      '\"Provayder\" — bu xidməti idarə edən qurum deməkdir.';

  @override
  String get userAgreementConceptSubtitle7 =>
      '\"Üçüncü tərəf\" — hər hansı xarici xidmət və ya qurum deməkdir.';

  @override
  String get userAgreementConceptSubtitle8 =>
      '\"Cihaz\" — xidmətə daxil olmaq üçün istifadə edilən hər hansı elektron cihaz deməkdir.';

  @override
  String get userAgreementConceptSubtitle9 =>
      '\"Yeniləmə\" — tətbiqə və ya şərtlərə edilən hər hansı dəyişiklik deməkdir.';

  @override
  String get userAgreementGeneralInformationTitle => 'Ümumi Məlumat';

  @override
  String get userAgreementGeneralInformationSubtitle =>
      'Aşağıdakı ümumi qaydalar tətbiq olunur:';

  @override
  String get userAgreementGeneralInformationOption1 =>
      'İstifadəçilər qeydiyyat zamanı dəqiq məlumat təqdim etməlidirlər.';

  @override
  String get userAgreementGeneralInformationOption2 =>
      'İstifadəçilər hesab təhlükəsizliyini qorumağa cavabdehdirlər.';

  @override
  String get userAgreementGeneralInformationOption3 =>
      'Xidmətdən sui-istifadə hesabın bağlanması ilə nəticələnə bilər.';

  @override
  String get privacyPolicySubtitle => 'Gizlilik Siyasəti';

  @override
  String get privacyPolicySubtext =>
      'Bu Gizlilik Siyasəti fərdi məlumatlarınızı necə topladığımızı, istifadə etdiyimizi və qoruduğumuzu izah edir.';

  @override
  String get privacyPolicyConceptTitle => 'Məlumat Toplanması';

  @override
  String get privacyPolicyConceptSubtitle =>
      'Aşağıdakı növ məlumatları toplayırıq:';

  @override
  String get privacyPolicyConceptSubtitle1 =>
      'Şəxsi müəyyənləşdirmə məlumatları (ad, e-poçt, telefon nömrəsi).';

  @override
  String get privacyPolicyConceptSubtitle2 =>
      'Cihaz məlumatları (model, ƏS versiyası).';

  @override
  String get privacyPolicyConceptSubtitle3 =>
      'Yer məlumatları (icazə verildikdə).';

  @override
  String get privacyPolicyConceptSubtitle4 =>
      'İstifadə analitikası və xəta hesabatları.';

  @override
  String get privacyPolicyConceptSubtitle5 =>
      'Torpaq nümunəsi məlumatları və sahə informasiyası.';

  @override
  String get privacyPolicyConceptSubtitle6 =>
      'Ünsiyyət üstünlükləri və rəylər.';

  @override
  String get privacyPolicyObligationTitle => 'Öhdəliklərimiz';

  @override
  String get privacyPolicyObligationSubtitle1 =>
      'Məlumatlarınızı sənaye standartı təhlükəsizlik tədbirləri ilə qoruyacağıq.';

  @override
  String get privacyPolicyObligationSubtitle2 =>
      'Fərdi məlumatlarınızı üçüncü tərəflərə satmayacağıq.';

  @override
  String get privacyPolicyObligationSubtitle3 =>
      'İstənilən vaxt dəstəklə əlaqə saxlayaraq məlumat silinməsini tələb edə bilərsiniz.';

  @override
  String get profilePageTitle => 'Profil';

  @override
  String get profilePageName => 'Ad Soyad';

  @override
  String get profilePageEmail => 'E-poçt';

  @override
  String get profilePagePhoneNumber => 'Telefon nömrəsi';

  @override
  String get profilePageEnterEmail => 'E-poçtunuzu daxil edin';

  @override
  String get profilePageEnterPhoneNumber => 'Telefon nömrənizi daxil edin';

  @override
  String get notificationPageHeader => 'Bildirişlər';

  @override
  String get notificationMarkAllAsRead => 'Hamısını oxunmuş et';

  @override
  String get notificationDeleteAllMessage => 'Hamısını sil';

  @override
  String get notificationSwipeDelete => 'Sil';

  @override
  String get notificationDetailClose => 'Bağla';

  @override
  String get notificationThereIsNoNotification => 'Hələ bildiriş yoxdur';

  @override
  String get notificationsLoading => 'Bildirişlər yüklənir...';

  @override
  String get notificationsError => 'Bildirişlər yüklənə bilmədi';

  @override
  String notificationUnreadCount(int count) {
    return '$count oxunmamış Bildiriş';
  }

  @override
  String get changeProfilePageTitle => 'Əlaqələndirilmiş Hesablar';

  @override
  String get changeProfilePageEmpty => 'Əlaqələndirilmiş hesab tapılmadı.';

  @override
  String get changeProfilePageAddNewAccountButton => 'Yeni Hesab Əlavə Et';

  @override
  String get deletePopupSuccessTitle => 'Uğurlu';

  @override
  String get deletePopupAccountRemoved => 'Hesab silindi.';

  @override
  String get deletePopupConfirmTitle => 'Silinməni Təsdiqləyin';

  @override
  String get deletePopupRemoveAccountMessage =>
      'Bu hesabı silmək istədiyinizdən əminsiniz?';

  @override
  String get deletePopupRemoveAccountAddedMeMessage =>
      'Bu hesab başqa istifadəçi tərəfindən əlaqələndirilib. Əlaqəni silmək istəyirsiniz?';

  @override
  String get linkedAccountOtpPageVerifyButton => 'Doğrula';

  @override
  String get linkedAccountOtpPagePhoneNumberSent =>
      'Doğrulama kodu göndərildi:';

  @override
  String get linkedAccountOtpPageEnterSixDigitCode =>
      '6 rəqəmli kodu daxil edin';

  @override
  String get linkedAccountSuccessPageTitle => 'Hesab əlaqələndirildi!';

  @override
  String get linkedAccountSuccessPageSubtitle =>
      'Hesab profilinizə uğurla əlaqələndirildi.';

  @override
  String get linkedAccountSuccessPageDoneButton => 'Hazır';

  @override
  String get storyPageSeeMore => 'Daha çox';

  @override
  String get sosMedical => 'Tibbi';

  @override
  String get sosTransport => 'Nəqliyyat';

  @override
  String get sosTravel => 'Səyahət';

  @override
  String get sosProperty => 'Əmlak';

  @override
  String get sosCallCenter => 'Əlaqə Mərkəzi';
}
