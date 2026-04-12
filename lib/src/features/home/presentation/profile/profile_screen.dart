import 'package:soilreport/src/common_widgets/otp_dialog.dart';
import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/features/home/presentation/profile/profile_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/async_value_ui.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    _emailController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));

    ref.watch(profileControllerProvider);
    final activeState =
        ref.read(profileControllerProvider.notifier).effectiveState;
    final controller = ref.read(profileControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    ref.listen<ProfileState>(profileControllerProvider, (prev, next) {
      final check = next.checkState;
      if (check == null) return;
      check.when(
        data: (data) {
          if (data == 'email_sent') {
            _showOtpDialog(
              email: _emailController.text,
              phoneNumber: next.phoneNumber,
              pin: '',
              isEmailVerifyOtp: true,
            );
          } else if (data == 'sms_sent') {
            _showOtpDialog(
              email: next.email,
              phoneNumber: _phoneController.text,
              pin: '',
              isEmailVerifyOtp: false,
            );
          } else {
            _emailController.text = next.email;
            _phoneController.text = next.phoneNumber;
          }
        },
        loading: () {},
        error: (error, stackTrace) => check.showAlertOnError(context),
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Skeletonizer(
        enabled: activeState.checkState.isNullOrLoading,
        effect: PulseEffect(
          from: AppTheme().gray900Theme(context).withAlpha(90),
          to: AppTheme().gray900Theme(context).withAlpha(240),
          duration: const Duration(milliseconds: 800),
        ),
        child: _buildContent(context, activeState, controller, l10n),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProfileState profileState,
    ProfileController controller,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 100.devicePaddingTop(context)),
            _buildHeader(context, l10n),
            const SizedBox(height: 10),
            _buildProfilePictureSection(context, controller),
            const SizedBox(height: 10),
            _buildNameSection(context, profileState, l10n),
            const SizedBox(height: 10),
            _buildEmailSection(context, profileState, controller, l10n),
            const SizedBox(height: 10),
            _buildPhoneNumberSection(context, profileState, controller, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/static/arrow-left.png',
                width: 30,
                color: AppTheme().orange,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                l10n.profilePageTitle,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: context.isDarkMode
                          ? AppTheme().white
                          : AppTheme().black,
                    ),
              ),
            ),
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection(
      BuildContext context, ProfileController controller) {
    return Container(
      height: 124,
      padding: const EdgeInsets.only(top: 30, bottom: 15),
      child: Row(
        children: [
          const Spacer(),
          SizedBox(
            width: 90,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    margin: const EdgeInsets.only(bottom: 7),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-icon-eps-file-easy-to-edit-default-avatar-photo-placeholder-profile-icon-124557887.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 2,
                  child: GestureDetector(
                    onTap: () => controller.changeProfilePicture(),
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? AppTheme().surfaceLight700
                            : AppTheme().surfaceDark700,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/static/square-pen.png',
                        width: 20,
                        height: 20,
                        color: context.isDarkMode
                            ? AppTheme().black
                            : AppTheme().white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildNameSection(
      BuildContext context, ProfileState profileState, AppLocalizations l10n) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profilePageName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.isDarkMode
                      ? AppTheme().white
                      : AppTheme().black,
                ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                profileState.user.fullName ?? '',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme().orange,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailSection(
    BuildContext context,
    ProfileState profileState,
    ProfileController controller,
    AppLocalizations l10n,
  ) {
    final hasChanged = _emailController.text != profileState.email;
    return Container(
      height: 90,
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profilePageEmail,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.isDarkMode
                      ? AppTheme().white
                      : AppTheme().black,
                ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? AppTheme().surfaceDark700
                        : Colors.transparent,
                    border: Border.all(
                      color: context.isDarkMode
                          ? AppTheme().gray600
                          : AppTheme().gray100,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onSubmitted: hasChanged
                        ? (_) =>
                            controller.confirmEmail(_emailController.text)
                        : null,
                    controller: _emailController,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme().orange, fontSize: 19),
                    decoration: InputDecoration(
                      hintText: l10n.profilePageEnterEmail,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                              color: AppTheme().gray300, fontSize: 19),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: hasChanged
                    ? () =>
                        controller.confirmEmail(_emailController.text)
                    : null,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  width: 20,
                  height: 20,
                  child: Image.asset(
                    hasChanged
                        ? 'assets/images/static/check.png'
                        : 'assets/images/static/square-pen.png',
                    color: AppTheme().orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberSection(
    BuildContext context,
    ProfileState profileState,
    ProfileController controller,
    AppLocalizations l10n,
  ) {
    final hasChanged = _phoneController.text != profileState.phoneNumber;
    return Container(
      height: 90,
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profilePagePhoneNumber,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.isDarkMode
                      ? AppTheme().white
                      : AppTheme().black,
                ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? AppTheme().surfaceDark700
                        : Colors.transparent,
                    border: Border.all(
                      color: context.isDarkMode
                          ? AppTheme().gray600
                          : AppTheme().gray100,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _phoneController,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme().orange, fontSize: 19),
                    decoration: InputDecoration(
                      hintText: l10n.profilePageEnterPhoneNumber,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                              color: AppTheme().gray300, fontSize: 19),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 10),
                    ),
                    onSubmitted: hasChanged
                        ? (_) => controller
                            .confirmPhoneNumber(_phoneController.text)
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: hasChanged
                    ? () => controller
                        .confirmPhoneNumber(_phoneController.text)
                    : null,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  width: 20,
                  height: 20,
                  child: Image.asset(
                    hasChanged
                        ? 'assets/images/static/check.png'
                        : 'assets/images/static/square-pen.png',
                    color: AppTheme().orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOtpDialog({
    required String email,
    required String phoneNumber,
    required String pin,
    required bool isEmailVerifyOtp,
  }) {
    showOtpDialog(
      context: context,
      email: email,
      phoneNumber: phoneNumber,
      pin: pin,
      isEmailVerifyOtp: isEmailVerifyOtp,
      onOtpVerified: () {
        ref.read(profileControllerProvider.notifier).loadUserData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification successful!'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
