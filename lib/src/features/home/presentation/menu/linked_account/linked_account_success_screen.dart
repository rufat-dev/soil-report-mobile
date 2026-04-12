import 'package:soilreport/src/common_widgets/page_widget.dart';
import 'package:soilreport/src/core/utils/string_extension.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/features/home/presentation/menu/linked_account/change_account_screen_controller.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'linked_account_success_controller.dart';

class LinkedAccountSuccessScreen extends ConsumerStatefulWidget {
  final String fullName;
  final String pinCode;

  const LinkedAccountSuccessScreen({
    super.key,
    required this.fullName,
    required this.pinCode,
  });

  @override
  ConsumerState<LinkedAccountSuccessScreen> createState() => _LinkedAccountSuccessScreenState();
}

class _LinkedAccountSuccessScreenState extends ConsumerState<LinkedAccountSuccessScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(linkedAccountSuccessControllerProvider.notifier).initialize(
            fullName: widget.fullName,
            pinCode: widget.pinCode,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(linkedAccountSuccessControllerProvider);
    ref.listen(linkedAccountSuccessControllerProvider, (previous, next) async {
      final state = next.checkState;
      if (state == null || state == previous?.checkState) return;

      await state.when(
        data: (value) async {
          if (value != LinkedAccountSuccessController.doneState) return;
          final router = GoRouter.of(context);
          if (router.canPop()) {
            router.pop();
          }
          if (router.canPop()) {
            router.pop();
          }
          await ref.read(changeAccountScreenControllerProvider.notifier).refreshConnections();
        },
        error: (_, __) async {},
        loading: () async {},
      );
    });
    final activeState = ref.read(linkedAccountSuccessControllerProvider.notifier).effectiveState;
    final controller = ref.read(linkedAccountSuccessControllerProvider.notifier);

    return PageWidget(
      isLoading: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 36),
              _buildSuccessIcon(context),
              const SizedBox(height: 30),
              Text(
                'LinkedAccountSuccessPage.Title'.translate(context),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'LinkedAccountSuccessPage.Subtitle'.translate(context),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.isDarkMode ? const Color(0xFF888888) : AppTheme().gray500,
                    ),
              ),
              const SizedBox(height: 20),
              _buildLinkedAccountCard(context, activeState),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.done,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme().orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'LinkedAccountSuccessPage.DoneButton'.translate(context),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon(BuildContext context) {
    final outerColor = context.isDarkMode ? const Color(0xFF1A1A1A) : AppTheme().gray200;
    const green = Color(0xFF4CAF50);
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: outerColor,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: green,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '✓',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedAccountCard(BuildContext context, LinkedAccountSuccessState state) {
    final initial = state.fullName.isNullOrEmpty
        ? '?'
        : state.fullName.trim().substring(0, 1).toUpperCase();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.isDarkMode ? const Color(0xFF1A1A1A) : AppTheme().gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              state.pinCode,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
