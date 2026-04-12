import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/features/home/presentation/components/dashboard_banner.dart';
import 'package:soilreport/src/features/home/presentation/components/dashboard_pending_sign.dart';
import 'package:soilreport/src/features/home/presentation/components/sos_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/dashboard_header.dart';
import '../components/dashboard_stats.dart';
import '../components/dashboard_stories.dart';
import 'dashboard_screen_controller.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.sw(context),
      color: Theme.of(context).colorScheme.surface,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(dashboardScreenControllerProvider.notifier).loadScreen(useCache: false);
        },
        child: Stack(
          children: [
            SizedBox(
              width: 100.sw(context),
              height: 100.sh(context),
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      SizedBox(height: 100.devicePaddingTop(context)),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: 70,
                        child: const DashboardHeader(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: double.maxFinite,
                        child: const DashboardStats() ,
                      ),
                      const SizedBox(
                          height: 15
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        height: 107,
                        width: double.maxFinite,
                        child: const DashboardStories(),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: double.maxFinite,
                        child: const DashboardPendingSign(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                        alignment: Alignment.centerLeft,
                        width: 100.sw(context),
                        child: DashboardBanner(),
                      ),
                    ]
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 20,
              child: GestureDetector(
                onTap: () => showSosBottomSheet(context),
                child: Image.asset("assets/images/static/siren.png",width: 70,)),
              )
          ],
        ),
      ),
    );
  }
}
