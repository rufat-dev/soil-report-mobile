import 'package:soilreport/src/constants/app_sizes.dart';
import 'package:soilreport/src/core/services/connectivity_service.dart';
import 'package:soilreport/src/features/authentication/domain/auth_alert_type.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/routing/app_router.dart';
import 'package:soilreport/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_alert_screen_controller.dart';

class AuthAlertScreen extends ConsumerStatefulWidget {
  final AuthAlertType alertType;

  const AuthAlertScreen({super.key, required this.alertType});

  @override
  ConsumerState<AuthAlertScreen> createState() => _AuthAlertScreenState();
}

class _AuthAlertScreenState extends ConsumerState<AuthAlertScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authAlertScreenControllerProvider.notifier).setAlertType(widget.alertType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authAlertScreenControllerProvider);
    final controller = ref.read(authAlertScreenControllerProvider.notifier);
    final connectivityStatus = ref.watch(connectivityStatusChangesProvider).value;
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<AuthAlertScreenState>(authAlertScreenControllerProvider, (prev, next) {
      next.checkState?.when(
        data: (_) => context.goNamed(AppRoute.loading.name),
        error: (err, _) => next.checkState?.showAlertOnError(context),
        loading: () {},
      );
    });

    final alertKey = controller.getAlertKey();
    final hasServerConnection =
        connectivityStatus == ConnectivityStatus.hasServerConnection;
    final displayedAlertKey =
        hasServerConnection ? 'Auth.Alert.HasConnection' : alertKey;
    final isLoading = state.checkState?.isLoading ?? false;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p24),
          child: Column(
            children: [
              const Spacer(),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: hasServerConnection
                          ? colorScheme.primary.withAlpha(15)
                          : colorScheme.error.withAlpha(15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      hasServerConnection ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                      size: 56,
                      color: hasServerConnection
                          ? colorScheme.primary
                          : colorScheme.error,
                    ),
                  ),
                  gapH24,
                  Text(
                    displayedAlertKey.translate(context),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () async => await controller.retry(),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          (hasServerConnection ? 'Auth.Proceed' : 'Auth.Retry')
                              .translate(context),
                        ),
                ),
              ),
              gapH20,
            ],
          ),
        ),
      ),
    );
  }
}
