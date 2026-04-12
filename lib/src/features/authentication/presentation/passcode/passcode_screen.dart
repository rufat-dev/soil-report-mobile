import 'dart:ui';

import 'package:soilreport/src/common_widgets/page_widget.dart';
import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/features/authentication/presentation/passcode/passcode_screen_controller.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/routing/app_router.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/utils/async_value_ui.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PasscodeScreen extends ConsumerStatefulWidget {
  const PasscodeScreen({super.key});

  @override
  ConsumerState<PasscodeScreen> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends ConsumerState<PasscodeScreen> {


  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      final isFirstLogin = await ref.read(passcodeScreenControllerProvider.notifier).isFirstLogin();
      if (!isFirstLogin) {
        await ref.read(passcodeScreenControllerProvider.notifier).biometrics();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
      ref.listen<PasscodeScreenState>(
      passcodeScreenControllerProvider,
          (prev, next) {
          final check = next.checkState;
          if (check == null || check == prev?.checkState) return;
          check.when(
            data: (_) => context.goNamed(AppRoute.home.name),
            error: (err, _) => check.showAlertOnError(context),
            loading: () {},
          );
        },
    );

    final state = ref.watch(passcodeScreenControllerProvider);
    _controller.text = state.input;
    return PageWidget(
      isLoading: state.checkState?.isLoading ?? false,
      body: Padding(
        padding: EdgeInsets.only(
            top: 100.devicePaddingTop(context),
            left: 35,
            right: 35
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Common.SoilplantTitle".translate(context),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 20)
            ),
            const SizedBox(
              height: 80,
            ),
            Text(
              "PassCodePage.FingerPrint.Header".translate(context),                
              style: Theme.of(context).textTheme.displayMedium
            
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  letterSpacing: 4,
                  fontSize: 19
              ),
              controller: _controller,
              enabled: false,
              decoration: InputDecoration.collapsed(
                  hintText: "●●●●",
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      letterSpacing: 4,
                      fontSize: 19
                  )
              ),
            ),
            const SizedBox(height: 40,),
            Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 15.sw(context),
                      width: 70.sw(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref.read(passcodeScreenControllerProvider.notifier).updateInput("1"),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "1",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref.read(passcodeScreenControllerProvider.notifier).updateInput("2"),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "2",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref.read(passcodeScreenControllerProvider.notifier).updateInput("3"),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "3",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.sw(context),
                      width: 70.sw(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref.read(passcodeScreenControllerProvider.notifier).updateInput("4"),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "4",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref.read(passcodeScreenControllerProvider.notifier).updateInput("5"),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "5",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref.read(passcodeScreenControllerProvider.notifier).updateInput("6"),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "6",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.sw(context),
                      width: 70.sw(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref.read(passcodeScreenControllerProvider.notifier).updateInput("7"),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "7",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref.read(passcodeScreenControllerProvider.notifier).updateInput("8"),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "8",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref.read(passcodeScreenControllerProvider.notifier).updateInput("9"),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "9",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.sw(context),
                      width: 70.sw(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref.read(passcodeScreenControllerProvider.notifier).updateInput("f"),
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/static/fingerprint.png",
                                    height: 25,)
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                ref
                                    .read(passcodeScreenControllerProvider
                                        .notifier)
                                    .updateInput("0");
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "0",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => ref.read(passcodeScreenControllerProvider.notifier).updateInput("r"),
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/static/delete.png",
                                    height: 25,
                                    color: context.isDarkMode ? Colors.white : Colors.black,
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            const SizedBox(height: 150,)
          ],
        ),
      ),
    );
  }

}
