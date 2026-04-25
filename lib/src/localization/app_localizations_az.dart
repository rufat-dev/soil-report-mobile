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
  String get dashboardStatDevicesLabel => 'Cihazlar';

  @override
  String get dashboardStatGroupsLabel => 'Qruplar';

  @override
  String get dashboardStatOperationStatusesLabel => 'Statuslar';

  @override
  String get dashboardDevicesSectionTitle => 'Cihazlar';

  @override
  String get dashboardDevicesEmptyTitle => 'Hələ cihaz yoxdur';

  @override
  String get dashboardDevicesEmptySubtitle =>
      'Torpaq məlumatlarını görmək üçün aldığınız cihazı əlavə edin.';

  @override
  String get dashboardDevicesAddButton => 'Cihaz əlavə et';

  @override
  String get dashboardGroupsSectionTitle => 'Cihaz qrupları';

  @override
  String get dashboardGroupsEmptyTitle => 'Hələ qrup yoxdur';

  @override
  String get dashboardGroupsEmptySubtitle =>
      'Cihazları və ümumi tənzimləmələri təşkil etmək üçün qrup yaradın.';

  @override
  String get dashboardGroupsAddButton => 'Qrup əlavə et';

  @override
  String get addGroupTitle => 'Qrup əlavə et';

  @override
  String get addGroupNameLabel => 'Qrup adı';

  @override
  String get addGroupNotesLabel => 'Qeydlər (istəyə bağlı)';

  @override
  String get addGroupSubmitButton => 'Qrup yarat';

  @override
  String get addGroupSuccessTitle => 'Qrup yaradıldı';

  @override
  String get addGroupSuccessSubtitle => 'Qrup uğurla saxlanıldı.';

  @override
  String get addGroupErrorTitle => 'Qrup yaradıla bilmədi';

  @override
  String get addGroupErrorSubtitle => 'Məlumatları yoxlayıb yenidən cəhd edin.';

  @override
  String get addGroupRequiredField => 'Bu sahə məcburidir.';

  @override
  String get addGroupUngroupedDevicesTitle => 'Qrupsuz cihazlar';

  @override
  String get addGroupNoUngroupedDevices =>
      'Qrupsuz cihazınız yoxdur. Cihaz əlavə edin və ya birini qrupdan çıxarın.';

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
  String get emptyStatisticsTitle => 'Hələ statistika yoxdur';

  @override
  String get emptyStatisticsSubtitle =>
      'Cihaz torpaq oxunuşlarını göndərdikdən sonra məlumat görünəcək.';

  @override
  String get emptyAlertsTitle => 'Hələ xəbərdarlıq yoxdur';

  @override
  String get emptyAlertsSubtitle =>
      'Sahələr diqqət tələb etdikdə xəbərdarlıqlar burada görünəcək.';

  @override
  String get emptyRecommendationsTitle => 'Hələ tövsiyə yoxdur';

  @override
  String get emptyRecommendationsSubtitle =>
      'Kifayət qədər məlumat toplandıqdan sonra tövsiyələr burada görünəcək.';

  @override
  String get recommendationsNoItems => 'Hazırda tövsiyə yoxdur';

  @override
  String get addDeviceTitle => 'Cihaz əlavə et';

  @override
  String get addDeviceIdLabel => 'Cihaz ID';

  @override
  String get addDeviceNameLabel => 'Cihaz adı';

  @override
  String get addDeviceGroupDropdownLabel => 'Cihaz qrupu';

  @override
  String get addDeviceGroupNoneOption => 'Yoxdur';

  @override
  String get addDevicePlantDropdownLabel => 'Bitki növü';

  @override
  String get addDeviceSoilDropdownLabel => 'Torpaq növü';

  @override
  String get addDevicePlantFallbackName => 'Bitki';

  @override
  String get addDeviceSoilFallbackName => 'Torpaq';

  @override
  String get addDeviceGroupAutofillInfo =>
      'Bitki və torpaq növü seçilmiş qrupdakı cihazdan avtomatik doldurulur.';

  @override
  String get addDeviceLocationLabel => 'Məkan';

  @override
  String get addDeviceLocationNotSelected => 'Məkan seçilməyib';

  @override
  String get addDeviceLocationNameLabel => 'Məkan adı / qeydi';

  @override
  String get addDeviceFirmwareLabel => 'Firmware versiyası';

  @override
  String get addDeviceSubmitButton => 'Cihazı göndər';

  @override
  String get addDeviceSuccessTitle => 'Cihaz əlavə edildi';

  @override
  String get addDeviceSuccessSubtitle => 'Cihaz uğurla hesabınıza bağlandı.';

  @override
  String get addDeviceErrorTitle => 'Cihaz əlavə edilə bilmədi';

  @override
  String get addDeviceErrorSubtitle =>
      'Məlumatları yoxlayıb yenidən cəhd edin.';

  @override
  String get addDeviceRequiredField => 'Bu sahə məcburidir.';

  @override
  String get addDeviceMapTitle => 'Məkan seçimi';

  @override
  String get addDeviceMapConfirmButton => 'Bu məkanı istifadə et';

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

  @override
  String get commonGoHome => 'Ana səhifəyə keç';

  @override
  String get notFoundPageMessage => '404 - Səhifə tapılmadı!';

  @override
  String get authAuthorizationFailedTryAgain =>
      'Avtorizasiya uğursuz oldu. Yenidən cəhd edin.';

  @override
  String get loginEmailLabel => 'E-poçt';

  @override
  String get loginResetPasswordTitle => 'Şifrəni sıfırla';

  @override
  String get loginEmailRequired => 'E-poçt məcburidir';

  @override
  String get loginEmailHint => 'E-poçt';

  @override
  String get loginResetPasswordSend => 'Göndər';

  @override
  String get recommendationsHeaderSubtitle =>
      'Hazırda diqqət tələb edən və yaxın zamanda risk yarada biləcək məsələlər üçün prioritetli tövsiyələr axını.';

  @override
  String get recommendationsEmptyStableSubtitle =>
      'Hazırda tövsiyə yoxdur. Quruluşunuz stabil görünür.';

  @override
  String get recommendationsNeedsAttentionTitle => 'Diqqət tələb edir';

  @override
  String get recommendationsNeedsAttentionSubtitle =>
      'İlk növbədə icra edilməli yüksək prioritetli addımlar.';

  @override
  String get recommendationsSuggestedActionsTitle => 'Təklif olunan addımlar';

  @override
  String get recommendationsSuggestedActionsSubtitle =>
      'Növbəti yoxlamalar və optimizasiya tövsiyələri.';

  @override
  String get recommendationsForecastOutlookTitle => 'Proqnoz görünüşü';

  @override
  String get recommendationsForecastOutlookSubtitle =>
      'Proqnozlaşdırılan şərait və mümkün risk siqnalları.';

  @override
  String recommendationsDeviceLabel(String siteLabel) {
    return 'Cihaz: $siteLabel';
  }

  @override
  String get recommendationsNoForecastHorizon => 'Proqnoz müddəti yoxdur';

  @override
  String get recommendationsUnknownDevice => 'Naməlum cihaz';

  @override
  String recommendationsDeviceShort(String id) {
    return 'Cihaz $id';
  }

  @override
  String get recommendationsPredictedMetric => 'Proqnoz göstəricisi';

  @override
  String get recommendationsCategoryFertilization => 'Gübrələmə';

  @override
  String get recommendationsCategoryIrrigation => 'Suvarma';

  @override
  String get recommendationsCategorySoil => 'Torpaq';

  @override
  String get recommendationsCategoryPest => 'Zərərverici';

  @override
  String get recommendationsCategoryGeneral => 'Ümumi';

  @override
  String recommendationsRecencyMinutesAgo(int count) {
    return '$count dəq əvvəl';
  }

  @override
  String recommendationsRecencyHoursAgo(int count) {
    return '$count saat əvvəl';
  }

  @override
  String recommendationsRecencyDaysAgo(int count) {
    return '$count gün əvvəl';
  }

  @override
  String get recommendationsRiskMonitor => 'İzlə';

  @override
  String get recommendationsRiskWatch => 'Nəzarətdə saxla';

  @override
  String get recommendationsRiskRisk => 'Risk';

  @override
  String get recommendationsRiskStable => 'Stabil';

  @override
  String recommendationsSummaryUrgent(int count) {
    return '$count təcili';
  }

  @override
  String recommendationsSummarySuggested(int count) {
    return '$count təklif';
  }

  @override
  String recommendationsSummaryForecasts(int count) {
    return '$count proqnoz';
  }

  @override
  String get recommendationsLoadErrorTitle => 'Tövsiyələr yüklənə bilmədi';

  @override
  String get recommendationsLoadErrorSubtitle =>
      'Sessiyanın vaxtı bitmiş ola bilər. Yeniləyin və ya yenidən cəhd edin.';

  @override
  String get otpEmailVerificationTitle => 'E-poçt təsdiqi';

  @override
  String get otpPhoneVerificationTitle => 'Telefon təsdiqi';

  @override
  String otpEnterCodeSentTo(String channel) {
    return '$channel ünvanına göndərilmiş 6 rəqəmli kodu daxil edin';
  }

  @override
  String get otpEmailChannel => 'e-poçt';

  @override
  String get otpPhoneChannel => 'telefon';

  @override
  String get otpCodeHint => '------';

  @override
  String otpCodeExpiresInSeconds(int seconds) {
    return 'Kodun vaxtı: $seconds saniyə';
  }

  @override
  String get otpResendEmail => 'E-poçtu yenidən göndər';

  @override
  String get otpResendSms => 'SMS-i yenidən göndər';

  @override
  String get otpCancel => 'Ləğv et';

  @override
  String get profileVerificationSuccessful => 'Təsdiq uğurludur!';

  @override
  String get changeAccountAddNewAccountTapped => 'Yeni hesab əlavə et seçildi';

  @override
  String sosCallLaunchError(String phoneNumber) {
    return '$phoneNumber nömrəsinə zəng etmək mümkün olmadı';
  }

  @override
  String get sosGettingLocation => 'Məkanınız alınır...';

  @override
  String get sosLocationRequiredTitle => 'Məkan tələb olunur';

  @override
  String get sosLocationRequiredBody =>
      'SOS xidmətləri üçün məkan girişi tələb olunur. Zəhmət olmasa cihaz ayarlarında məkan xidmətlərini aktiv edin.';

  @override
  String get sosLocationCancel => 'Ləğv et';

  @override
  String get sosLocationOpenSettings => 'Ayarları aç';

  @override
  String get exceptionPasswordNotMatch => 'Şifrələr uyğun gəlmir';

  @override
  String get exceptionPasswordInvalid => 'Şifrə düzgün deyil';

  @override
  String get exceptionCouldNotSetPassword => 'Şifrə təyin edilə bilmədi';

  @override
  String get exceptionWrongPhoneNumber => 'Yanlış telefon nömrəsi';

  @override
  String get exceptionWrongOtp => 'Yanlış OTP kodu';

  @override
  String get exceptionClientStatsFetchFailed =>
      'Müştəri statistikası alına bilmədi';

  @override
  String get exceptionUserNotFound => 'İstifadəçi tapılmadı';

  @override
  String get exceptionNetworkIssue => 'Şəbəkə problemi';

  @override
  String get exceptionSystemError => 'Sistem xətası';

  @override
  String get exceptionBiometricAuthenticationFailed =>
      'Biometrik doğrulama uğursuz oldu';

  @override
  String get exceptionBiometricAuthenticationNotSupported =>
      'Biometrik doğrulama dəstəklənmir';

  @override
  String get exceptionJsonParse => 'Server cavabı emal edilə bilmədi';

  @override
  String get exceptionApiIssue => 'API-dən düzgün cavab alınmadı';

  @override
  String get exceptionUnauthorizedUser => 'İstifadəçi səlahiyyətli deyil';

  @override
  String get exceptionEmptyEmail => 'E-poçt boş ola bilməz';

  @override
  String get exceptionEmptyFullName => 'Ad soyad boş ola bilməz';

  @override
  String get exceptionInvalidFullName =>
      'Zəhmət olmasa ad soyadı tam daxil edin';

  @override
  String get exceptionInvalidEmailFormat =>
      'Zəhmət olmasa düzgün e-poçt ünvanı daxil edin';

  @override
  String get exceptionEmailVerificationFailed =>
      'Təsdiq e-poçtu göndərilə bilmədi. Yenidən cəhd edin.';

  @override
  String get exceptionEmptyPhoneNumber => 'Telefon nömrəsi boş ola bilməz';

  @override
  String get exceptionInvalidPhoneNumberFormat =>
      'Zəhmət olmasa düzgün telefon nömrəsi daxil edin';

  @override
  String get exceptionSmsVerificationFailed =>
      'Təsdiq SMS-i göndərilə bilmədi. Yenidən cəhd edin.';

  @override
  String get exceptionProfileUpdateError =>
      'Profil yenilənərkən xəta baş verdi';
}
