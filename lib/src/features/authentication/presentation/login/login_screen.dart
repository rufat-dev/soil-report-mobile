import 'package:soilreport/src/common_widgets/page_widget.dart';
import 'package:soilreport/src/common_widgets/text_input_widget.dart';
import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/app_router.dart';
import 'login_screen_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  bool _hasLoggedIn = false;
  bool _showResetSuccess = false;
  AnimationController? _successAnimationController;
  Animation<double>? _successScaleAnimation;
  Animation<double>? _successOpacityAnimation;

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();
    final initialEmail = _emailTextController.text.trim();
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ResetPasswordDialog(
        initialEmail: initialEmail,
        onSubmit: (email) =>
            ref.read(loginScreenControllerProvider.notifier).sendPasswordReset(email),
      ),
    );
    if (ok == true) {
      await _showSuccessIcon();
    }
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _ensureSuccessAnimation();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _successAnimationController?.dispose();
    super.dispose();
  }

  void _ensureSuccessAnimation() {
    if (_successAnimationController != null) return;
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _successAnimationController = controller;
    _successScaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );
    _successOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _showSuccessIcon() async {
    if (!mounted) return;
    _ensureSuccessAnimation();
    final controller = _successAnimationController;
    if (controller == null) return;
    setState(() => _showResetSuccess = true);
    await controller.forward();
    await Future<void>.delayed(const Duration(milliseconds: 650));
    await controller.reverse();
    if (mounted) {
      setState(() => _showResetSuccess = false);
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    _hasLoggedIn = true;
    ref
        .read(loginScreenControllerProvider.notifier)
        .logIn(
          email: _emailTextController.text,
          password: _passwordTextController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      loginScreenControllerProvider,
      (_, state) {
        if (!_hasLoggedIn) return;
        state.when(
          data: (_) => context.goNamed(AppRoute.passcode.name),
          error: (err, _) => state.showAlertOnError(context),
          loading: () {},
        );
      },
    );

    final state = ref.watch(loginScreenControllerProvider);

    return PageWidget(
      isLoading: state.isLoading,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 100.devicePaddingTop(context),
              left: 35,
              right: 35,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  bottom: 18.safeAreaH(context),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  "Common.SoilplantTitle".translate(context),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
            Text(
              "EMAIL",
              style: Theme.of(context).textTheme.displaySmall!.merge(
                const TextStyle(inherit: true, fontSize: 11),
              ),
            ),
            const SizedBox(height: 10),
            TextInputWidget(
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              focusNode: _emailFocusNode,
              controller: _emailTextController,
              textAlign: TextAlign.start,
              autofocus: true,
              trailing: TextInputLucideIcons.icon(context, 'mail.png'),
              onSubmitted: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
            ),
            const SizedBox(height: 18),
            Text(
              "Common.Password".translate(context).toUpperCase(),
              style: Theme.of(context).textTheme.displaySmall!.merge(
                const TextStyle(inherit: true, fontSize: 11),
              ),
            ),
            const SizedBox(height: 10),
            TextInputWidget(
              autofillHints: const [AutofillHints.password],
              focusNode: _passwordFocusNode,
              controller: _passwordTextController,
              obscureText: true,
              textAlign: TextAlign.start,
              trailing: TextInputLucideIcons.icon(context, 'lock.png'),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: _submit,
              child: Container(
                width: double.maxFinite,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  "Common.SignIn".translate(context).toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "LoginPage.ForgotPassword".translate(context),
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 7),
                GestureDetector(
                  onTap: () {
                    _resetPassword();
                  },
                  child: Text(
                    "LoginPage.RenewPassword".translate(context),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
              ],
            ),
          ),
          if (_showResetSuccess)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: FadeTransition(
                    opacity: _successOpacityAnimation ??
                        const AlwaysStoppedAnimation<double>(0),
                    child: ScaleTransition(
                      scale: _successScaleAnimation ??
                          const AlwaysStoppedAnimation<double>(1),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 40,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResetPasswordDialog extends StatefulWidget {
  const _ResetPasswordDialog({
    required this.initialEmail,
    required this.onSubmit,
  });

  final String initialEmail;
  final Future<void> Function(String email) onSubmit;

  @override
  State<_ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<_ResetPasswordDialog> {
  late final TextEditingController _emailController;
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Email is required');
      return;
    }

    setState(() {
      _error = null;
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(email);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Reset password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            enabled: !_isSubmitting,
            decoration: const InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 10),
          if (_error != null)
            Text(
              _error!,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
            ),
          if (_isSubmitting)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: const Text('Send'),
        ),
      ],
    );
  }
}
