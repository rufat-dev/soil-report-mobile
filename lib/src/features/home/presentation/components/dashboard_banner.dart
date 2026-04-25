import 'package:soilreport/src/features/home/presentation/dashboard_screen/dashboard_screen_controller.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/extensions/uri_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardBanner extends ConsumerWidget {
  const DashboardBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dashboardScreenControllerProvider);
    final activeState = ref.read(dashboardScreenControllerProvider.notifier).effectiveState;

    // Shimmer is handled by [DashboardScreen]'s root Skeletonizer; the old
    // enabled flag used [effectiveState].checkState and stayed off while real
    // checkState was still null (mockState reports data, not loading).
    return _buildBannerContent(context, activeState);
  }

  Widget _buildBannerContent(BuildContext context, DashboardScreenState activeState) {
    // State management based on banner data
    if (activeState.bannerImage == null || activeState.bannerImage!.isEmpty) {
      // None state - return empty container with 0 height
      return const SizedBox(height: 0);
    }

    // Success state - show banner
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: () async {
            if (activeState.bannerLink != null && activeState.bannerLink!.isNotEmpty) {
              try {
                final uri = Uri.parse(activeState.bannerLink!);
                await uri.launch();
              } catch (e) {
                // Handle error silently for banner links
              }
            }
          },
          child: Image.network(
            activeState.bannerImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: AppTheme().gray900Theme(context),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: AppTheme().gray900Theme(context),
                child: const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
