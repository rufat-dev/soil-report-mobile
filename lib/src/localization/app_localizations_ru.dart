// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Почвенный Отчёт';

  @override
  String get commonSignIn => 'Войти';

  @override
  String get commonPin => 'ПИН';

  @override
  String get commonPassword => 'Пароль';

  @override
  String get commonNext => 'Далее';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonYes => 'Да';

  @override
  String get commonNo => 'Нет';

  @override
  String get commonLanguage => 'Язык';

  @override
  String get commonLogout => 'Выход';

  @override
  String get commonAppTitle => 'Почвенный Отчёт';

  @override
  String get authAlertNetworkError =>
      'Нет подключения к сети. Проверьте интернет и попробуйте снова.';

  @override
  String get authAlertInternalNetworkError =>
      'Не удаётся связаться с сервером. Попробуйте позже.';

  @override
  String get authAlertUnknown =>
      'Произошла непредвиденная ошибка. Попробуйте снова.';

  @override
  String get authAlertHasConnection =>
      'Подключение восстановлено. Продолжаем...';

  @override
  String get authRetry => 'Повторить';

  @override
  String get authProceed => 'Продолжить';

  @override
  String get splashPlantCaption => 'Добро пожаловать в Почвенный Отчёт';

  @override
  String get splashPlantMessage =>
      'Следите за состоянием почвы, отслеживайте образцы и получайте практические рекомендации — всё в одном месте.';

  @override
  String get splashMonitorCaption => 'Полевой Анализ';

  @override
  String get splashMonitorMessage =>
      'Собирайте и отслеживайте образцы почвы на всех ваших участках с точностью GPS.';

  @override
  String get splashHarvestCaption => 'Мониторинг Участков';

  @override
  String get splashHarvestMessage =>
      'Следите за pH, влажностью, питательными веществами и органическими веществами для каждого участка.';

  @override
  String get splashDataCaption => 'Умные Рекомендации';

  @override
  String get splashDataMessage =>
      'Получайте рекомендации на основе ИИ по удобрению, орошению и улучшению почвы для ваших полей.';

  @override
  String get landingPageNewUser => 'Новый пользователь?';

  @override
  String get landingPageCreateAccount => 'Создать аккаунт';

  @override
  String get pinPageEnterPin => 'Введите ваш ПИН-код';

  @override
  String get pinPageEntryPin => 'ПИН';

  @override
  String get pinPageAcceptTermsAndConditions =>
      'Входя в систему, вы принимаете Условия и правила';

  @override
  String get passCodePageFingerPrintHeader => 'Используйте биометрию для входа';

  @override
  String get loginPageForgotPassword => 'Забыли пароль?';

  @override
  String get loginPageRenewPassword => 'Сбросить пароль';

  @override
  String get phoneNumberPageEnterPhoneNumber => 'Введите номер телефона';

  @override
  String get phoneVerifyPageOtpCodeSent =>
      'Код подтверждения отправлен на ваш телефон.';

  @override
  String get phoneVerifyPageEnterOptCode => 'Введите код подтверждения';

  @override
  String get phoneVerifyPageSmsTimerInfo =>
      'Не получили код? Повторная отправка через';

  @override
  String get phoneVerifyPageResendSms => 'Отправить код повторно';

  @override
  String get resetPasswordPageRepeatPassword => 'Новый пароль';

  @override
  String get resetPasswordPageConfirmNewPassword => 'Подтвердите новый пароль';

  @override
  String get resetPasswordPageConfirmPassword => 'Подтвердить';

  @override
  String get dashboardPageTitle => 'Главная';

  @override
  String get dashboardPageHi => 'Привет';

  @override
  String get dashboardPageWelcome => 'Добро пожаловать!';

  @override
  String get dashboardPagePeriodCount => 'Периоды';

  @override
  String get dashboardPagePolicies => 'Полисы';

  @override
  String get dashboardPageNoClaimsDaysCount => 'Дней без претензий';

  @override
  String get dashboardPagePendingSignCount => 'ожидающие документы';

  @override
  String get dashboardPageUrgentSignFile => 'Срочно: Требуется подпись';

  @override
  String get dashboardPageViewAllSignDocs => 'Показать все';

  @override
  String get tab1Title => 'Статистика';

  @override
  String get tab2Title => 'Оповещения';

  @override
  String get tab3Title => 'Рекомендации';

  @override
  String get statisticsRecentSamples => 'Последние образцы';

  @override
  String alertsActiveCount(int count) {
    return '$count активных оповещений';
  }

  @override
  String get alertsNoAlerts => 'Всё в порядке — активных оповещений нет';

  @override
  String get recommendationsNoItems => 'Сейчас рекомендаций нет';

  @override
  String get recommendationsMarkApplied => 'Применить';

  @override
  String get recommendationsApplied => 'Применено';

  @override
  String get recommendationsPriorityHigh => 'Высокий';

  @override
  String get recommendationsPriorityMedium => 'Средний';

  @override
  String get recommendationsPriorityLow => 'Низкий';

  @override
  String get menuPageTitle => 'Меню';

  @override
  String get menuPageChangeAccount => 'Сменить аккаунт';

  @override
  String get menuPageContracts => 'Контракты';

  @override
  String get menuPagePayments => 'Платежи';

  @override
  String get menuPageClaims => 'Заявки';

  @override
  String get menuPageConditionAndTerms => 'Условия и правила';

  @override
  String get menuPageSecurityPolicy => 'Политика безопасности';

  @override
  String get menuPageOfferPage => 'Предложения';

  @override
  String get menuPageFAQ => 'FAQ';

  @override
  String get menuPageFAQLife => 'FAQ Жизнь';

  @override
  String get menuPageChatBot => 'Чат-бот';

  @override
  String get menuPageContactUs => 'Связаться с нами';

  @override
  String get menuPageRemoveAccount => 'Удалить аккаунт';

  @override
  String get menuPageWarning => 'Предупреждение';

  @override
  String get menuPageDeleteAccount =>
      'Вы уверены, что хотите удалить свой аккаунт? Это действие необратимо.';

  @override
  String get menuPageAcceptDelete => 'Удалить';

  @override
  String get menuPageRejectDelete => 'Отмена';

  @override
  String get menuSettingsTitle => 'Настройки';

  @override
  String get menuCardAccountTitle => 'Аккаунт';

  @override
  String get menuCardAccountSubtitle => 'Профиль, вход и связанные аккаунты.';

  @override
  String get menuCardMonitoringTitle => 'Мониторинг';

  @override
  String get menuCardMonitoringSubtitle =>
      'Статистика, оповещения по почве и рекомендации.';

  @override
  String get menuCardLegalTitle => 'Правовая информация';

  @override
  String get menuCardLegalSubtitle =>
      'Условия использования и политика безопасности.';

  @override
  String get menuCardSupportTitle => 'Поддержка';

  @override
  String get menuCardSupportSubtitle => 'FAQ и способы связи.';

  @override
  String get menuCardPreferencesTitle => 'Настройки приложения';

  @override
  String get menuCardPreferencesSubtitle => 'Язык и региональные параметры.';

  @override
  String get menuCardSessionTitle => 'Сессия';

  @override
  String get menuCardSessionSubtitle =>
      'Выйти или удалить аккаунт на этом устройстве.';

  @override
  String get offerPageTitle => 'Предложения и Отзывы';

  @override
  String get offerPageGeneral => 'Общее';

  @override
  String get offerPageMedical => 'Медицина';

  @override
  String get offerPageSuggestion => 'Предложение';

  @override
  String get offerPageComplaint => 'Жалоба';

  @override
  String get offerPageComments => 'Напишите ваши комментарии здесь...';

  @override
  String get offerPageSubmit => 'Отправить';

  @override
  String get offerPageCommentError =>
      'Пожалуйста, введите комментарий перед отправкой.';

  @override
  String get offerPageCancelErrorMessage =>
      'Что-то пошло не так. Попробуйте снова.';

  @override
  String get offerPageSuccessMessage => 'Ваш отзыв успешно отправлен!';

  @override
  String get userAgreementTitle => 'Условия и правила';

  @override
  String get userAgreementAddress => '123 Пример улицы, Баку, Азербайджан';

  @override
  String get userAgreementTelephone => 'Тел: +994 12 000 00 00';

  @override
  String get userAgreementEmail => 'Email: info@example.com';

  @override
  String get userAgreementWebsite => 'Сайт: example.com';

  @override
  String get userAgreementLicense => 'Лицензия: #000000';

  @override
  String get userAgreementSubtitle => 'Условия использования';

  @override
  String get userAgreementSubtext1 =>
      'Настоящие Условия использования регулируют ваше пользование приложением.';

  @override
  String get userAgreementSubtext2 =>
      'Используя приложение, вы соглашаетесь с этими условиями.';

  @override
  String get userAgreementSubtext3 =>
      'Мы оставляем за собой право обновлять эти условия в любое время.';

  @override
  String get userAgreementSubtext4 =>
      'Продолжение использования после изменений означает принятие.';

  @override
  String get userAgreementConceptTitle => 'Основные понятия';

  @override
  String get userAgreementConceptSubtitle1 =>
      '\"Сервис\" — относится к мобильному приложению Почвенный Отчёт.';

  @override
  String get userAgreementConceptSubtitle2 =>
      '\"Пользователь\" — любое лицо, которое загружает и использует приложение.';

  @override
  String get userAgreementConceptSubtitle3 =>
      '\"Контент\" — данные, текст и информация, предоставляемые через приложение.';

  @override
  String get userAgreementConceptSubtitle4 =>
      '\"Персональные данные\" — любая информация, идентифицирующая пользователя.';

  @override
  String get userAgreementConceptSubtitle5 =>
      '\"Аккаунт\" — зарегистрированный профиль пользователя в приложении.';

  @override
  String get userAgreementConceptSubtitle6 =>
      '\"Провайдер\" — организация, управляющая данным сервисом.';

  @override
  String get userAgreementConceptSubtitle7 =>
      '\"Третья сторона\" — любой внешний сервис или организация.';

  @override
  String get userAgreementConceptSubtitle8 =>
      '\"Устройство\" — любое электронное устройство для доступа к сервису.';

  @override
  String get userAgreementConceptSubtitle9 =>
      '\"Обновление\" — любое изменение приложения или его условий.';

  @override
  String get userAgreementGeneralInformationTitle => 'Общая информация';

  @override
  String get userAgreementGeneralInformationSubtitle =>
      'Применяются следующие общие правила:';

  @override
  String get userAgreementGeneralInformationOption1 =>
      'Пользователи должны предоставлять точную информацию при регистрации.';

  @override
  String get userAgreementGeneralInformationOption2 =>
      'Пользователи несут ответственность за безопасность своего аккаунта.';

  @override
  String get userAgreementGeneralInformationOption3 =>
      'Злоупотребление сервисом может привести к блокировке аккаунта.';

  @override
  String get privacyPolicySubtitle => 'Политика конфиденциальности';

  @override
  String get privacyPolicySubtext =>
      'Данная Политика конфиденциальности объясняет, как мы собираем, используем и защищаем ваши персональные данные.';

  @override
  String get privacyPolicyConceptTitle => 'Сбор данных';

  @override
  String get privacyPolicyConceptSubtitle =>
      'Мы собираем следующие типы данных:';

  @override
  String get privacyPolicyConceptSubtitle1 =>
      'Личная идентификационная информация (имя, email, номер телефона).';

  @override
  String get privacyPolicyConceptSubtitle2 =>
      'Информация об устройстве (модель, версия ОС).';

  @override
  String get privacyPolicyConceptSubtitle3 =>
      'Данные о местоположении (при наличии разрешения).';

  @override
  String get privacyPolicyConceptSubtitle4 =>
      'Аналитика использования и отчёты об ошибках.';

  @override
  String get privacyPolicyConceptSubtitle5 =>
      'Данные образцов почвы и информация о полях.';

  @override
  String get privacyPolicyConceptSubtitle6 => 'Предпочтения связи и отзывы.';

  @override
  String get privacyPolicyObligationTitle => 'Наши обязательства';

  @override
  String get privacyPolicyObligationSubtitle1 =>
      'Мы защитим ваши данные с помощью стандартных мер безопасности.';

  @override
  String get privacyPolicyObligationSubtitle2 =>
      'Мы не будем продавать ваши персональные данные третьим лицам.';

  @override
  String get privacyPolicyObligationSubtitle3 =>
      'Вы можете запросить удаление данных в любое время, обратившись в поддержку.';

  @override
  String get profilePageTitle => 'Профиль';

  @override
  String get profilePageName => 'Полное имя';

  @override
  String get profilePageEmail => 'Эл. почта';

  @override
  String get profilePagePhoneNumber => 'Номер телефона';

  @override
  String get profilePageEnterEmail => 'Введите email';

  @override
  String get profilePageEnterPhoneNumber => 'Введите номер телефона';

  @override
  String get notificationPageHeader => 'Уведомления';

  @override
  String get notificationMarkAllAsRead => 'Отметить все как прочитанные';

  @override
  String get notificationDeleteAllMessage => 'Удалить все';

  @override
  String get notificationSwipeDelete => 'Удалить';

  @override
  String get notificationDetailClose => 'Закрыть';

  @override
  String get notificationThereIsNoNotification => 'Уведомлений пока нет';

  @override
  String get notificationsLoading => 'Загрузка уведомлений...';

  @override
  String get notificationsError => 'Не удалось загрузить уведомления';

  @override
  String notificationUnreadCount(int count) {
    return '$count непрочитанных уведомлений';
  }

  @override
  String get changeProfilePageTitle => 'Связанные аккаунты';

  @override
  String get changeProfilePageEmpty => 'Связанных аккаунтов не найдено.';

  @override
  String get changeProfilePageAddNewAccountButton => 'Добавить новый аккаунт';

  @override
  String get deletePopupSuccessTitle => 'Успешно';

  @override
  String get deletePopupAccountRemoved => 'Аккаунт удалён.';

  @override
  String get deletePopupConfirmTitle => 'Подтвердите удаление';

  @override
  String get deletePopupRemoveAccountMessage =>
      'Вы уверены, что хотите удалить этот аккаунт?';

  @override
  String get deletePopupRemoveAccountAddedMeMessage =>
      'Этот аккаунт был связан другим пользователем. Удалить связь?';

  @override
  String get linkedAccountOtpPageVerifyButton => 'Подтвердить';

  @override
  String get linkedAccountOtpPagePhoneNumberSent =>
      'Код подтверждения отправлен на';

  @override
  String get linkedAccountOtpPageEnterSixDigitCode => 'Введите 6-значный код';

  @override
  String get linkedAccountSuccessPageTitle => 'Аккаунт связан!';

  @override
  String get linkedAccountSuccessPageSubtitle =>
      'Аккаунт успешно связан с вашим профилем.';

  @override
  String get linkedAccountSuccessPageDoneButton => 'Готово';

  @override
  String get storyPageSeeMore => 'Подробнее';

  @override
  String get sosMedical => 'Медицина';

  @override
  String get sosTransport => 'Транспорт';

  @override
  String get sosTravel => 'Путешествия';

  @override
  String get sosProperty => 'Имущество';

  @override
  String get sosCallCenter => 'Колл-центр';
}
