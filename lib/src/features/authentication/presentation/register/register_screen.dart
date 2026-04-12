import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/routing/app_router.dart';
import 'package:soilreport/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soilreport/src/common_widgets/page_widget.dart';
import 'package:soilreport/src/common_widgets/text_input_widget.dart';
import 'register_screen_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({
    super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();
  final _fullNameTextController = TextEditingController();

  late FocusNode _fullNameFocusNode ;
  late FocusNode _emailFocusNode ;
  late FocusNode _passwordFocusNode ;
  late FocusNode _phoneNumberFocusNode ;

  @override
  void initState() {
    super.initState();
    _fullNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _phoneNumberTextController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      registerScreenControllerProvider,
          (_, state) {
        state.when(
            data: (_) => context.goNamed(AppRoute.landing.name),
            error: (err, _) => state.showAlertOnError(context),
            loading: (){}
        );
      },
    );

    final state = ref.watch(registerScreenControllerProvider);

    return PageWidget(
      body: Padding(
        padding: EdgeInsets.only(
            top: 100.devicePaddingTop(context),
            left: 35,
            right: 35
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 30,
              ),
              child: Text(
                  textAlign: TextAlign.center,
                  "Common.SoilplantTitle".translate(context),
                  style: Theme.of(context).textTheme.headlineLarge

              ),
            ),
            const SizedBox(height: 50,),
            Text(
              "PinPage.EnterPin".translate(context),
                style: Theme.of(context).textTheme.displaySmall

            ),
            const SizedBox(height: 18),
            TextInputWidget(
              controller: _fullNameTextController,
              focusNode: _fullNameFocusNode,
              autofocus: true,
              hintText: "Full Name".translate(context),
              textAlign: TextAlign.start,
              trailing: TextInputLucideIcons.icon(context, 'user.png'),
              onSubmitted: (_){
                FocusManager.instance.primaryFocus?.unfocus();
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
            ),
            const SizedBox(height: 20),
            TextInputWidget(
              controller: _emailTextController,
              focusNode: _emailFocusNode,
              autofocus: false,
              hintText: "Email".translate(context),
              textAlign: TextAlign.start,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              trailing: TextInputLucideIcons.icon(context, 'mail.png'),
              onSubmitted: (_){
                FocusManager.instance.primaryFocus?.unfocus();
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextInputWidget(
              controller: _passwordTextController,
              focusNode: _passwordFocusNode,
              autofocus: false,
              hintText: "Password".translate(context),
              textAlign: TextAlign.start,
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              trailing: TextInputLucideIcons.icon(context, 'lock.png'),
              onSubmitted: (_){
                FocusManager.instance.primaryFocus?.unfocus();
                FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
              },
            ),
            const SizedBox(height: 20),
            TextInputWidget(
              controller: _phoneNumberTextController,
              focusNode: _phoneNumberFocusNode,
              autofocus: false,
              maxLength: 24,
              hintText: "Phone Number".translate(context),
              textAlign: TextAlign.start,
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumber],
              trailing: TextInputLucideIcons.icon(context, 'phone.png'),
              onSubmitted: (_){
                FocusManager.instance.primaryFocus?.unfocus();
                ref
                    .read(registerScreenControllerProvider.notifier)
                    .tryRegister(_fullNameTextController.text, _emailTextController.text, _passwordTextController.text, _phoneNumberTextController.text);
              },
            ),
            const SizedBox(height: 20),
            Text(
              "PinPage.AcceptTermsAndConditions".translate(context),
              style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => ref
                  .read(registerScreenControllerProvider.notifier)
                  .tryRegister(_fullNameTextController.text, _emailTextController.text, _passwordTextController.text, _phoneNumberTextController.text),
              child: Container(
                width: double.maxFinite,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).primaryColor
                ),
                child: Text(
                  "Common.Next".translate(context).toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
      isLoading: state.isLoading,
    );

  }
}
