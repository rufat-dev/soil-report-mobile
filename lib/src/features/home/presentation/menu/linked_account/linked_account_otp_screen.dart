import 'package:soilreport/src/common_widgets/page_widget.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/routing/app_router.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'linked_account_otp_controller.dart';

class LinkedAccountOtpScreen extends ConsumerStatefulWidget {
  final String pinCode;
  final String? phoneNumber;
  const LinkedAccountOtpScreen({
    super.key,
    required this.pinCode,
    this.phoneNumber,
  });

  @override
  ConsumerState<LinkedAccountOtpScreen> createState() => _LinkedAccountOtpScreenState();
}

class _LinkedAccountOtpScreenState extends ConsumerState<LinkedAccountOtpScreen> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(linkedAccountOtpControllerProvider.notifier).initialize(
            pinCode: widget.pinCode,
            phoneNumber: widget.phoneNumber,
          );
      _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeState =ref.watch(linkedAccountOtpControllerProvider);
    ref.listen(linkedAccountOtpControllerProvider, (previous, next){
      final state = next.checkState;
      if(state == null || state == previous?.checkState) return;
      state.when(
        data: (pinCode) {
          context.pushNamed(
            AppRoute.linkedAccountSuccess.name,
            extra: {
              'pinCode': pinCode ?? activeState.pinCode,
              'fullName': '',
            },
          );
        },
        error: (e,s) => state.showAlertOnError(context),
        loading: () => {},
      );
    });
    final controller = ref.read(linkedAccountOtpControllerProvider.notifier);
    final isLoading = activeState.checkState?.isLoading ?? false;
    
    return PageWidget(
      isLoading: isLoading,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context, controller),
                  const SizedBox(height: 30),
                  _buildStepIndicator(context),
                  const SizedBox(height: 30),
                  _buildOtpIcon(context),
                  const SizedBox(height: 30),
                  _buildTitleSection(context, activeState),
                  const SizedBox(height: 30),
                  _buildOtpInputs(context, controller),
                  const SizedBox(height: 25),
                  Center(
                    child: TextButton(
                      onPressed: activeState.isResendEnabled
                          ? () => controller.resendOtp()
                          : null,
                      child: Text(
                        activeState.timerText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.isDarkMode
                                  ? const Color(0xFF888888)
                                  : AppTheme().gray500,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Opacity(
                    opacity: activeState.isConfirmEnabled ? 1 : 0.4,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: activeState.isConfirmEnabled
                            ? () async =>
                                  await controller.confirmOtp()
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme().orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'LinkedAccountOtpPage.VerifyButton'.translate(context),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, LinkedAccountOtpController controller) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () => context.pop(),
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
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    final gray = context.isDarkMode ? const Color(0xFF1A1A1A) : AppTheme().gray300;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(AppTheme().orange),
        _buildLine(AppTheme().orange),
        _buildDot(AppTheme().orange),
        _buildLine(gray),
        _buildDot(gray),
      ],
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildLine(Color color) {
    return Container(
      width: 94,
      height: 2,
      color: color,
      margin: const EdgeInsets.symmetric(horizontal: 5),
    );
  }

  Widget _buildOtpIcon(BuildContext context) {
    final circleColor = context.isDarkMode ? const Color(0xFF1A1A1A) : AppTheme().gray200;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          ),
          Container(
            width: 48,
            height: 60,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 32,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: AppTheme().orange, width: 2),
                    color: Colors.transparent,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (_) => Container(
                      width: 20,
                      height: 2,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: AppTheme().orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, LinkedAccountOtpState state) {
    final phoneNumber = state.phoneNumber;
    return Column(
      children: [
        Text(
          'PhoneVerifyPage.EnterOptCode'.translate(context),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        if (phoneNumber.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            "${'LinkedAccountOtpPage.PhoneNumberSent'.translate(context)} $phoneNumber",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.isDarkMode ? const Color(0xFF888888) : AppTheme().gray500,
                ),
          ),
        ],
        const SizedBox(height: 10),
        Text(
          'LinkedAccountOtpPage.EnterSixDigitCode'.translate(context),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.isDarkMode ? const Color(0xFF888888) : AppTheme().gray500,
              ),
        ),
      ],
    );
  }

  Widget _buildOtpInputs(BuildContext context, LinkedAccountOtpController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
        (index) => _buildOtpBox(context, controller, index),
      ),
    );
  }

  Widget _buildOtpBox(BuildContext context, LinkedAccountOtpController controller, int index) {
    final backgroundColor = context.isDarkMode ? const Color(0xFF1A1A1A) : AppTheme().gray100;
    final borderColor = context.isDarkMode ? const Color(0xFF333333) : AppTheme().gray300;

    return Container(
      width: 45,
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        onChanged: (value) {
          controller.updateOtpDigit(index + 1, value);
          if (value.isNotEmpty && index < _focusNodes.length - 1) {
            _focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}

