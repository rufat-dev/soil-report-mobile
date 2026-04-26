import 'package:soilreport/src/common_widgets/lucide_themed_icon.dart';
import 'package:soilreport/src/common_widgets/destructive_confirmation_dialog.dart';
import 'package:soilreport/src/constants/urls.dart';
import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/features/home/presentation/menu/menu_screen_controller.dart';
import 'package:soilreport/src/features/home/presentation/tabbed_screen/tabbed_screen.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/localization/localization_repository.dart';
import 'package:soilreport/src/utils/extensions/uri_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soilreport/src/routing/app_router.dart';
import '../../../../utils/app_theme.dart';
import '../../../authentication/data/auth_repository.dart';
import 'package:soilreport/src/common_widgets/alert_dialogs.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  /// Same fill as the former full-width divider (`_divider`).
  Color get _cardFill => AppTheme().white.withAlpha(20);

  /// Visible edge on top of the semi-transparent card surface.
  Color get _cardBorderColor => Colors.black.withAlpha(72);

  /// Slightly stronger than [_cardFill] so the field reads inside the card.
  Color get _dropdownFieldFill => AppTheme().white.withAlpha(38);

  /// Overlay menu: same family as cards (not default dark Material gray).
  Color get _dropdownMenuColor => AppTheme().white.withAlpha(44);

  static const Color _pageText = Colors.white;

  static const List<({String code, String label})> _languageOptions =
      <({String code, String label})>[
    (code: 'az', label: 'Azərbaycanca'),
    (code: 'en', label: 'English'),
    (code: 'ru', label: 'Русский'),
  ];

  @override
  Widget build(BuildContext context) {
    String version = '';
    bool isRealScope = true;
    ref.watch(versionAndLanguageProvider).when(
          data: (data) => (version, isRealScope) = data,
          error: (_, __) {},
          loading: () {},
        );

    final locale = ref.watch(localeProvider).value;

    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: context.isDarkMode
          ? AppTheme().surfaceDark
          : Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100.devicePaddingTop(context) + 15),
                  
                  _buildTopNavigationButtons(l10n),
                  const SizedBox(height: 20),
                  _buildMenuCard(
                    context,
                    title: l10n.menuCardAccountTitle,
                    subtitle: l10n.menuCardAccountSubtitle,
                    children: [
                      _buildMenuRow(
                        context,
                        'user-plus.png',
                        l10n.profilePageTitle,
                        () => context.pushNamed(AppRoute.profile.name),
                      ),
                    ],
                  ),
                  _buildMenuCard(
                    context,
                    title: l10n.menuCardMonitoringTitle,
                    subtitle: l10n.menuCardMonitoringSubtitle,
                    children: [
                      _buildMenuRow(
                        context,
                        'bar-chart-3.png',
                        l10n.tab1Title,
                        () {
                          context.pop();
                          ref.read(tabIndexProvider.notifier).state = 1;
                        },
                      ),
                      _buildMenuRow(
                        context,
                        'bell-ring.png',
                        l10n.tab2Title,
                        () {
                          context.pop();
                          ref.read(tabIndexProvider.notifier).state = 2;
                        },
                      ),
                      _buildMenuRow(
                        context,
                        'lightbulb.png',
                        l10n.tab3Title,
                        () {
                          context.pop();
                          ref.read(tabIndexProvider.notifier).state = 3;
                        },
                      ),
                    ],
                  ),
                  _buildMenuCard(
                    context,
                    title: l10n.menuCardSupportTitle,
                    subtitle: l10n.menuCardSupportSubtitle,
                    children: [
                      _buildMenuRow(
                        context,
                        'circle-help.png',
                        l10n.menuPageFAQ,
                        () async {
                          try {
                            final uri = Uri.parse('${Urls.websiteUrl}faq');
                            await uri.launchWithTitle(l10n.menuPageFAQ);
                          } catch (_) {}
                        },
                      ),
                      _buildMenuRow(
                        context,
                        'mail.png',
                        l10n.menuPageContactUs,
                        () async {
                          try {
                            final uri = Uri.parse('mailto:ruf31145@gmail.com');
                            await uri.launchWithTitle(l10n.menuPageContactUs);
                          } catch (_) {}
                        },
                      ),
                    ],
                  ),
                  _buildMenuCard(
                    context,
                    title: l10n.menuCardPreferencesTitle,
                    subtitle: l10n.menuCardPreferencesSubtitle,
                    children: [
                      _buildLanguageDropdownRow(context, l10n, locale),
                    ],
                  ),
                  _buildMenuCard(
                    context,
                    title: l10n.menuCardSessionTitle,
                    subtitle: l10n.menuCardSessionSubtitle,
                    children: [
                      _buildMenuRow(
                        context,
                        'log-out.png',
                        l10n.commonLogout,
                        () {
                          _performLogout();
                        },
                      ),
                      if (isRealScope)
                        _buildMenuRow(
                          context,
                          'log-out.png',
                          l10n.menuPageRemoveAccount,
                          () => _showDeleteAccountDialog(context, l10n),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 45, right: 25, top: 15, bottom: 25),
            child: Row(
              children: [
                Text(
                  version,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: _pageText.withAlpha(220),
                      ),
                ),
                const Expanded(child: SizedBox.shrink()),
                _socialIcon(context, 'share-2.png', '', 22),
                const SizedBox(width: 5),
                _socialIcon(context, 'camera.png', '', 20),
                const SizedBox(width: 5),
                _socialIcon(context, 'briefcase.png', '', 20),
                const SizedBox(width: 5),
                _socialIcon(context, 'play-circle.png', '', 25),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _cardFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _cardBorderColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: _pageText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: _pageText.withAlpha(200),
                ),
              ),
              const SizedBox(height: 4),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuRow(
    BuildContext context,
    String lucideFileName,
    String title,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LucideThemedIcon(
              fileName: lucideFileName,
              size: 24,
              color: _pageText,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: _pageText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(
    BuildContext context,
    String lucideFileName,
    String url,
    double width,
  ) {
    return GestureDetector(
      onTap: () async {
        try {
          // await Uri.parse(url).launch();
        } catch (_) {}
      },
      child: LucideThemedIcon(
        fileName: lucideFileName,
        size: width,
        color: _pageText.withAlpha(230),
      ),
    );
  }

  Widget _buildTopNavigationButtons(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: LucideThemedIcon(
              fileName: 'arrow-left.png',
              size: 25,
              color: _pageText,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                l10n.menuSettingsTitle,
                style: const TextStyle(
                  color: _pageText,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    await ref.read(authRepositoryProvider).signOut();
    if (!mounted) return;
    context.goNamed(AppRoute.landing.name);
  }

  Future<void> _showDeleteAccountDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final shouldDelete = await showDestructiveConfirmationDialog(
      context: context,
      title: l10n.menuPageRemoveAccount,
      message: l10n.menuPageDeleteAccount,
      confirmText: l10n.menuPageRemoveAccount,
      cancelText: l10n.menuPageRejectDelete,
    );
    if (!shouldDelete || !mounted) return;
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      if (!context.mounted) return;
      context.goNamed(AppRoute.landing.name);
    } catch (e) {
      if (!context.mounted) return;
      await showExceptionAlert(
        context: context,
        title: l10n.menuPageWarning,
        exception: e,
      );
    }
  }

  String _resolvedLanguageCode(Locale? locale) {
    final c = locale?.languageCode ?? 'en';
    if (c == 'az' || c == 'en' || c == 'ru') return c;
    return 'en';
  }

  Widget _buildLanguageDropdownRow(
    BuildContext context,
    AppLocalizations l10n,
    Locale? locale,
  ) {
    final code = _resolvedLanguageCode(locale);
    final itemStyle = const TextStyle(
      fontSize: 15,
      color: _pageText,
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LucideThemedIcon(
                fileName: 'languages.png',
                size: 24,
                color: _pageText,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  l10n.commonLanguage,
                  style: const TextStyle(
                    fontSize: 15,
                    color: _pageText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _dropdownFieldFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _cardBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: code,
                        alignment: AlignmentDirectional.centerStart,
                        padding: EdgeInsets.zero,
                        style: itemStyle,
                        dropdownColor: _dropdownMenuColor,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 2,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: _pageText.withAlpha(230),
                        ),
                        iconSize: 28,
                        onChanged: (v) async {
                          if (v == null) return;
                          await ref
                              .read(localizationRepositoryProvider)
                              .setLocale(localeCode: v);
                        },
                        selectedItemBuilder: (context) => [
                          for (final o in _languageOptions)
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                o.label,
                                style: itemStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        items: [
                          for (final o in _languageOptions)
                            DropdownMenuItem<String>(
                              value: o.code,
                              child: Text(
                                o.label,
                                style: itemStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
            ],
          ),
    );
  }
}
