import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/features/home/domain/purchase_record_model.dart';
import 'package:soilreport/src/features/home/presentation/profile/profile_controller.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/async_value_ui.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  ProviderSubscription<ProfileState>? _profileSub;

  @override
  void initState() {
    super.initState();
    _profileSub = ref.listenManual<ProfileState>(
      profileControllerProvider,
      (_, next) {
        final check = next.checkState;
        if (check == null || !mounted) return;
        check.when(
          data: (data) {
            if (data == null || !mounted) return;
            String? message;
            if (data == 'verification_sent') {
              message = 'Verification email sent. Check your inbox.';
            } else if (data == 'password_reset_sent') {
              message = 'Password reset email sent.';
            }
            if (message == null) return;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message!)),
              );
            });
          },
          loading: () {},
          error: (error, stackTrace) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              check.showAlertOnError(context);
            });
          },
        );
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(profileControllerProvider);
    final state = ref.read(profileControllerProvider.notifier).effectiveState;
    final controller = ref.read(profileControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final background = context.isDarkMode
        ? AppTheme().surfaceDark
        : Color.alphaBlend(
            scheme.primary.withValues(alpha: 0.08),
            scheme.surface,
          );

    return Scaffold(
      backgroundColor: background,
      body: Skeletonizer(
        enabled: state.checkState.isNullOrLoading,
        effect: AppTheme().skeletonPulseEffect(context),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100.devicePaddingTop(context) + 8),
              _buildHeader(context),
              const SizedBox(height: 14),
              _buildProfileHeaderCard(context, state),
              const SizedBox(height: 12),
              _buildEmailVerificationCard(context, state, controller),
              const SizedBox(height: 12),
              _buildSecurityCard(context, state, controller),
              const SizedBox(height: 12),
              _buildPurchasesCard(context, state),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme().elevatedSurface(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Profile',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderCard(BuildContext context, ProfileState state) {
    final scheme = Theme.of(context).colorScheme;
    final initials = _initials(state.displayName, state.email);
    final accountId = state.firebaseUser?.localId ?? state.user.pin;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme().appCardDecoration(context, borderRadius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primary.withValues(alpha: 0.14),
                ),
                child: Text(
                  initials,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.email ?? 'No email',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme().elevatedSurface(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Account ID: $accountId',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailVerificationCard(
    BuildContext context,
    ProfileState state,
    ProfileController controller,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final verified = state.isEmailVerified;
    final email = state.email ?? '';
    final color = verified ? AppTheme().success : AppTheme().warning;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme().appCardDecoration(context, borderRadius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify Email',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            verified
                ? 'Your email is verified and ready for account recovery.'
                : 'Email is not verified yet. Verify to improve account security.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    verified ? 'Verified' : 'Not verified',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => controller.refreshVerificationStatus(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(96, 40),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Refresh'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!verified)
            FilledButton.icon(
              onPressed: email.trim().isEmpty
                  ? null
                  : () => controller.sendEmailVerification(),
              icon: const Icon(Icons.mark_email_unread_outlined, size: 18),
              label: const Text('Send verification email'),
            ),
          if (verified)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                'Verified: $email',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard(
    BuildContext context,
    ProfileState state,
    ProfileController controller,
  ) {
    final email = state.email ?? '';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme().appCardDecoration(context, borderRadius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reset Password',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Send a reset link to your current account email.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme().elevatedSurface(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Reset email: ${email.isEmpty ? 'Not available' : email}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: email.trim().isEmpty
                ? null
                : () => controller.sendPasswordReset(),
            icon: const Icon(Icons.lock_reset_rounded, size: 18),
            label: const Text('Send password reset email'),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasesCard(BuildContext context, ProfileState state) {
    final scheme = Theme.of(context).colorScheme;
    final purchases = [...state.purchases]
      ..sort((a, b) {
        final aa = a.purchaseDateTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bb = b.purchaseDateTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bb.compareTo(aa);
      });
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme().appCardDecoration(context, borderRadius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Purchases',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Text(
                '${purchases.length} items',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Recent account purchases and statuses.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          if (state.purchasesError != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: scheme.error.withValues(alpha: 0.25)),
              ),
              child: Text(
                state.purchasesError!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.error,
                    ),
              ),
            )
          else if (purchases.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme().elevatedSurface(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'No purchases yet. Purchases linked to your account will appear here.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          else
            ...purchases.take(6).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _PurchaseItemTile(item: item),
                  ),
                ),
        ],
      ),
    );
  }

  String _initials(String displayName, String? email) {
    final name = displayName.trim();
    if (name.isNotEmpty) {
      final parts = name.split(' ').where((e) => e.isNotEmpty).toList();
      if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
      return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
          .toUpperCase();
    }
    final e = (email ?? '').trim();
    return e.isEmpty ? 'A' : e.substring(0, 1).toUpperCase();
  }

  @override
  void dispose() {
    _profileSub?.close();
    super.dispose();
  }
}

class _PurchaseItemTile extends StatelessWidget {
  const _PurchaseItemTile({required this.item});

  final PurchaseRecordModel item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = switch (item.status) {
      1 => ('Completed', AppTheme().success),
      2 => ('Pending', AppTheme().warning),
      3 => ('Failed', scheme.error),
      _ => ('Unknown', scheme.onSurfaceVariant),
    };
    final when = item.purchaseDateTime;
    final dateText = when == null
        ? 'Date unknown'
        : '${when.day.toString().padLeft(2, '0')}.${when.month.toString().padLeft(2, '0')}.${when.year}';
    final amount = item.price == null || item.price!.isEmpty
        ? '—'
        : '${item.price} ${item.currency ?? ''}'.trim();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme().elevatedSurface(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme().cardBorderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Device ${item.deviceId}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: status.$2.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status.$1,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: status.$2,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Amount: $amount  •  $dateText',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (item.notes?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: 2),
            Text(
              item.notes!,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ],
      ),
    );
  }
}
