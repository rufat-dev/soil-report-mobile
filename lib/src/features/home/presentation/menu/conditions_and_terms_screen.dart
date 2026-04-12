import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/utils/app_theme.dart';  
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConditionsAndTermsScreen extends StatelessWidget {
  const ConditionsAndTermsScreen({super.key});

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
                "UserAgreement.Subtitle".translate(context),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 20),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "UserAgreement.Subtext1".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.Subtext2".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.Subtext3".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.Subtext4".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "UserAgreement.ConceptTitle".translate(context),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "UserAgreement.ConceptSubtitle1".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.ConceptSubtitle2".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.ConceptSubtitle3".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.ConceptSubtitle4".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.ConceptSubtitle5".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.ConceptSubtitle6".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.ConceptSubtitle7".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.ConceptSubtitle8".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.ConceptSubtitle9".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "UserAgreement.GeneralInformationTitle".translate(context),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "UserAgreement.GeneralInformationSubtitle".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.GeneralInformationOption1".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.GeneralInformationOption2".translate(context),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "UserAgreement.GeneralInformationOption3".translate(context),
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