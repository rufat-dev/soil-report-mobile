import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SecurityPolicyScreen extends StatelessWidget {
  const SecurityPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).colorScheme.surface,
    
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100.devicePaddingTop(context) + 20,
              ),
              Row(
                children: [
                  const SizedBox(width: 10,),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Image.asset(
                      "assets/images/static/arrow-left.png",
                      color: context.isDarkMode ? Colors.white : Colors.black, 
                      height: 25,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                          "UserAgreement.Title".translate(context),
                          style: Theme.of(context).textTheme.displayLarge,
                        )
                      )
                  ),
                  SizedBox(width: 35),
                ],
              ),
              const SizedBox(height: 45),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    "assets/images/static/sprout.png",
                    width: 150,
                  ),
                  const SizedBox(width: 15),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "UserAgreement.Address".translate(context),
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 3,),
                      Text(
                        "UserAgreement.Telephone".translate(context),
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 3,),
                      Text(
                        "UserAgreement.Email".translate(context),
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 3,),
                      Text(
                        "UserAgreement.Website".translate(context),
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 3,),
                      Text(
                        "UserAgreement.Lisence".translate(context),
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                )
                  ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "PrivacyPolicy.Subtitle".translate(context),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 20),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "PrivacyPolicy.Subtext".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "PrivacyPolicy.ConceptTitle".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "PrivacyPolicy.ConceptSubtitle".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "PrivacyPolicy.ConceptSubtitle1".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "PrivacyPolicy.ConceptSubtitle2".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "PrivacyPolicy.ConceptSubtitle3".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "PrivacyPolicy.ConceptSubtitle4".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "PrivacyPolicy.ConceptSubtitle5".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "PrivacyPolicy.ConceptSubtitle6".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "PrivacyPolicy.ObligationTitle".translate(context),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "PrivacyPolicy.ObligationSubtitle1".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "PrivacyPolicy.ObligationSubtitle2".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "PrivacyPolicy.ObligationSubtitle3".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),

              SizedBox(
                height: 100.devicePaddingBottom(context) + 10,
              ),
            ],
          ),
        ),
      ));
  }
}