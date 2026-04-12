import 'package:soilreport/src/features/home/presentation/dashboard_screen/dashboard_screen_controller.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../utils/app_theme.dart';

/// Placeholder stories widget.
/// Shows shimmer skeletons while loading, otherwise empty when no stories are available.
class DashboardStories extends ConsumerWidget {
  const DashboardStories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dashboardScreenControllerProvider);
    final activeState = ref
        .read(dashboardScreenControllerProvider.notifier)
        .effectiveState;

    if (activeState.stories.isEmpty &&
        !(activeState.checkState.isNullOrLoading)) {
      return const SizedBox.shrink();
    }

    return Skeletonizer(
      enabled: activeState.checkState.isNullOrLoading,
      effect: PulseEffect(
        from: AppTheme().gray900Theme(context).withAlpha(100),
        to: AppTheme().gray900Theme(context).withAlpha(240),
        duration: const Duration(milliseconds: 800),
      ),
      child: activeState.stories.isEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(right: 17),
                child: Skeleton.leaf(
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
