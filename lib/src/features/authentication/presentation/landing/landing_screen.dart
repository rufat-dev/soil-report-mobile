import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/utils/context_shortcuts.dart';
import 'package:soilreport/src/utils/themed_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/app_router.dart';
import 'landing_screen_controller.dart';

class LandingScreen extends ConsumerStatefulWidget{
  final bool showAuthError;
  const LandingScreen({super.key, this.showAuthError = false});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  int currentPage = 0;
  List<Map<String,String>> carouselWidgets = [
    {
      "imageSource" : 'plant.png',
      "header" : "Splash.PlantCaption",
      "content" : "Splash.PlantMessage"
    },
    {
      "imageSource" : 'monitor.png',
      "header" : "Splash.MonitorCaption",
      "content" : "Splash.MonitorMessage",
    },
    {
      "imageSource" :'harvest.png',
      "header" : "Splash.HarvestCaption",
      "content" : "Splash.HarvestMessage"
    },
    {
      "imageSource" : 'database.png',
      "header" :  "Splash.DataCaption",
      "content" :   "Splash.DataMessage"
    }
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showAuthError && mounted) {
        final l10n = AppLocalizations.of(context);
        context.showSnackBar(
          ErrorSnackBar(
            message: l10n.authAuthorizationFailedTryAgain,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: 85.sw(context),
                child: PageView.builder(
                  onPageChanged: (value){
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: carouselWidgets.length,
                  itemBuilder: (context, index) => CarouselPage(
                    imageSource: carouselWidgets[index]["imageSource"]!,
                    header: carouselWidgets[index]["header"]!,
                    content: carouselWidgets[index]["content"]!,
                  ),
                ),
              ),
            ),
            Container(
              width: 67,
              height: 8,
              margin: const EdgeInsets.only(bottom: 32),
              alignment: Alignment.center,
              child: ListView.builder(
                itemCount: carouselWidgets.length,
                itemBuilder: (BuildContext context, int index) => buildDot(index: index),
                scrollDirection: Axis.horizontal,
              ),
            ),
            Container(
              height: 85,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => context.pushNamed(AppRoute.login.name),
                        child: Text("Common.SignIn".translate(context)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "LandingPage.NewUser".translate(context),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => context.pushNamed(AppRoute.register.name),
                  child: Text(
                    "LandingPage.CreateAccount".translate(context),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}){
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: currentPage == index
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant.withAlpha(80),
      ),
    );
  }
}

class CarouselPage extends StatelessWidget {
  CarouselPage({
    required this.imageSource,
    required this.header,
    required this.content,
    super.key});
  String imageSource;
  String header;
  String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image(
          image: AssetImage("assets/images/static/$imageSource"),
          width: 35.sw(context),
        ),
        const SizedBox(height: 20),
        FittedBox(
          fit: BoxFit.contain,
          child: Text(
            header.translate(context),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          alignment: Alignment.topCenter,
          height: 135,
          child: Text(
            content.translate(context),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
