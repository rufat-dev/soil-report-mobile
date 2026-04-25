import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soilreport/src/features/alerts/presentation/alerts_screen.dart';
import 'package:soilreport/src/features/recommendations/presentation/recommendation_screen.dart';
import 'package:soilreport/src/features/statistics/presentation/statistics_screen.dart';
import '../dashboard_screen/dashboard_screen.dart';
import '../dashboard_screen/dashboard_screen_controller.dart';

class TabbedScreen extends ConsumerStatefulWidget {
  const TabbedScreen({super.key});

  @override
  ConsumerState<TabbedScreen> createState() => _TabbedScreenState();
}

class _TabbedScreenState extends ConsumerState<TabbedScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.animation?.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardScreenControllerProvider.notifier).loadScreen();
      _tabController.addListener(() {
        ref.read(tabIndexProvider.notifier).state = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<int>(tabIndexProvider, (prev, next) {
      if (_tabController.index != next) {
        _tabController.animateTo(next);
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: TabBarView(
        controller: _tabController,
        children: const [
          DashboardScreen(),
          StatisticsScreen(),
          AlertsScreen(),
          RecommendationScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color:
                  Theme.of(context).dividerTheme.color ??
                  colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
        ),
        padding: EdgeInsets.only(
          top: 4,
          bottom: 50.devicePaddingBottom(context),
        ),
        child: TabBar(
          dividerHeight: 0,
          padding: EdgeInsets.zero,
          indicatorColor: Colors.transparent,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          controller: _tabController,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          tabs: [
            _buildTab(
              context,
              index: 0,
              icon: Icons.home_rounded,
              label: l10n.dashboardPageTitle,
            ),
            _buildTab(
              context,
              index: 1,
              icon: Icons.bar_chart_rounded,
              label: l10n.tab1Title,
            ),
            _buildTab(
              context,
              index: 2,
              icon: Icons.notifications_active_rounded,
              label: l10n.tab2Title,
            ),
            _buildTab(
              context,
              index: 3,
              icon: Icons.lightbulb_rounded,
              label: l10n.tab3Title,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    final anim = _tabController.animation!.value;
    final primary = Theme.of(context).colorScheme.primary;
    final inactive = Theme.of(context).colorScheme.onSurfaceVariant;

    double lerp;
    if (index == 0) {
      lerp = anim.clamp(0, 1);
    } else if (index == _tabController.length - 1) {
      lerp = ((index - 1) <= anim && anim <= index) ? index - anim : 1.0;
    } else {
      final left = (index - 1 <= anim && anim <= index) ? index - anim : 1.0;
      final right = (index <= anim && anim <= index + 1) ? anim - index : 0.0;
      lerp = left == 1.0 ? right.clamp(0, 1) : left.clamp(0, 1);
    }

    final color = Color.lerp(primary, inactive, lerp)!;

    return Tab(
      height: 56,
      iconMargin: const EdgeInsets.only(bottom: 4),
      icon: Icon(icon, size: 22, color: color),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: lerp < 0.5 ? FontWeight.w600 : FontWeight.w400,
          color: color,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

final tabIndexProvider = StateProvider<int>((ref) => 0);
