import 'package:soilreport/src/common_widgets/page_widget.dart';
import 'package:soilreport/src/core/utils/string_extension.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/routing/app_router.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/async_value_ui.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'change_account_screen_controller.dart';

class ChangeAccountScreen extends ConsumerStatefulWidget {
  const ChangeAccountScreen({super.key});

  @override
  ConsumerState<ChangeAccountScreen> createState() => _ChangeAccountScreenState();
}

class _ChangeAccountScreenState extends ConsumerState<ChangeAccountScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(changeAccountScreenControllerProvider.notifier).loadChangeAccountScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(changeAccountScreenControllerProvider);
    ref.listen(changeAccountScreenControllerProvider, (previous, next){
      final state = next.checkState;
      if (state == null || state == previous?.checkState) return;
      state.when(
        data: (value) async {
          if (value == ChangeAccountScreenController.changeProfileSuccessState) {
            context.goNamed(AppRoute.home.name);
            return;
          }
          if (value == ChangeAccountScreenController.deleteAccountSuccessState && context.mounted) {
            await showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('DeletePopup.SuccessTitle'.translate(context)),
                content: Text('DeletePopup.AccountRemoved'.translate(context)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Common.Close'.translate(context)),
                  ),
                ],
              ),
            );
          }
        },
        error: (e,s) => state.showAlertOnError(context),
        loading: () => {},
      );
    });   
    final activeState = ref.read(changeAccountScreenControllerProvider.notifier).effectiveState;
    final controller = ref.read(changeAccountScreenControllerProvider.notifier);

    return PageWidget(
        isLoading: activeState.isChangingAccount,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 10),
                Expanded(
                  child: _buildConnectionsSection(
                    context,
                    activeState.connectedAccounts,
                    activeState.checkState.isNullOrLoading,
                    controller,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final l10n = AppLocalizations.of(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.changeAccountAddNewAccountTapped)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme().orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'ChangeProfilePage.AddNewAccountButton'.translate(context),
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Center(
              child: Transform.rotate(
                angle: context.isDarkMode ? 0 : 3.14159,
                child: Image.asset(
                  context.isDarkMode
                      ? 'assets/images/static/arrow-left.png'
                      : 'assets/images/static/arrow-right.png',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            'ChangeProfilePage.Title'.translate(context),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 45),
      ],
    );
  }

  Widget _buildConnectionsSection(
    BuildContext context,
    List<ClientConnectionModel> accounts,
    bool isLoading,
    ChangeAccountScreenController controller,
  ) {
    final showSkeleton = isLoading;

    if (!showSkeleton && accounts.isEmpty) {
      return Center(
        child: Text(
          'ChangeProfilePage.Empty'.translate(context),
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Skeletonizer(
      enabled: showSkeleton,
      ignorePointers: showSkeleton,
      effect: PulseEffect(
        from: AppTheme().gray900Theme(context).withAlpha(90),
        to: AppTheme().gray900Theme(context).withAlpha(240),
        duration: const Duration(milliseconds: 800),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshConnections();
        },
        child: ListView.separated(
          itemCount: accounts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final account = accounts[index];
            return GestureDetector(
              onTap: showSkeleton
                  ? null
                  : () async => await controller.changeProfile(account),
              child: Container(
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 5),
                decoration: BoxDecoration(
                  color: context.isDarkMode ? AppTheme().surfaceDark800 : AppTheme().lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildAvatar(context, account),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.fullName ?? '',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                              
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            account.pin ?? '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.isDarkMode ? AppTheme().gray200 : AppTheme().gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    IconButton(
                      onPressed: showSkeleton ? null : () => _openDeleteAccountDialogBox(context, controller, account),
                      icon: Image.asset(
                        account.isAddedByOtherUser ?? false
                            ? 'assets/images/static/unlink.png'
                            : 'assets/images/static/x.png',
                        color: context.isDarkMode ? AppTheme().white : AppTheme().black,
                        width: account.isAddedByOtherUser ?? false ? 24 : 18,
                        height: account.isAddedByOtherUser ?? false ? 24 : 18,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, ClientConnectionModel account) {
    final initial = !account.fullName.isNullOrEmpty ? account.fullName!.trim().substring(0, 1).toUpperCase() : '?';
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.isDarkMode ? AppTheme().gray500 : AppTheme().gray200,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _openDeleteAccountDialogBox(
    BuildContext context,
    ChangeAccountScreenController controller,
    ClientConnectionModel account,
  ) async {
    final messageKey = account.isAddedByOtherUser ?? false
        ? 'DeletePopup.RemoveAccountAddedMeMessage'
        : 'DeletePopup.RemoveAccountMessage';

    final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('DeletePopup.ConfirmTitle'.translate(context)),
            content: Text(messageKey.translate(context)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Common.No'.translate(context)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Common.Yes'.translate(context)),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;
    await controller.removeLinkedAccount(account);
  }
}