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

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  bool _hasLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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
      body: Padding(
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
                    FocusScope.of(context).unfocus();
                    context.pushNamed(AppRoute.register.name);
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
    );
  }
}
