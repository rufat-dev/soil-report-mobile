import 'package:soilreport/src/common_widgets/page_widget.dart';
import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/utils/app_theme.dart';  
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key});

  @override
  ConsumerState<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends ConsumerState<OffersScreen> {

  final TextEditingController _controller = TextEditingController();

  bool _isloading = false;
  
  @override
  Widget build(BuildContext context) {
    ref.watch(soilplantOrMedical);
    return PageWidget(
      isLoading: _isloading,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100.devicePaddingTop(context) + 25,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Image.asset(
                    "assets/images/static/arrow-left.png",
                    color: context.isDarkMode ? Colors.white : AppTheme().black,
                    height: 25,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                        "OfferPage.Title".translate(context),
                        textWidthBasis: TextWidthBasis.longestLine,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 20
                        ),
                      )
                    )
                ),
                const SizedBox(width: 25),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              width: double.maxFinite,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => ref.read(soilplantOrMedical.notifier).state = (0 , ref.read(soilplantOrMedical).$2),
                      child: Container(
                        color: ref.read(soilplantOrMedical).$1 == 0 ? AppTheme().orange : AppTheme().orangeLight,
                        alignment: Alignment.center,
                        height: 40,
                        child: Text(
                          "OfferPage.Soilplant".translate(context),
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: ref.read(soilplantOrMedical).$1 == 0 ?
                              Colors.white : AppTheme().gray400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => ref.read(soilplantOrMedical.notifier).state = (1 , ref.read(soilplantOrMedical).$2),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        color: ref.read(soilplantOrMedical).$1 == 1 ? AppTheme().orange : AppTheme().orangeLight,
                        child: Text(
                          "OfferPage.Medical".translate(context),
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: ref.read(soilplantOrMedical).$1 == 1 ?
                              Colors.white : AppTheme().gray400,
                          ),
                        ),
                      ),
                    ),
                  )
                ] 
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.maxFinite,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => ref.read(soilplantOrMedical.notifier).state = (ref.read(soilplantOrMedical).$1 ,0),
                      child: Container(
                        color: ref.read(soilplantOrMedical).$2 == 0 ? AppTheme().orange : AppTheme().orangeLight,
                        alignment: Alignment.center,
                        height: 40,
                        child: Text(
                          "OfferPage.Suggestion".translate(context),
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: ref.read(soilplantOrMedical).$2 == 0 ?
                              Colors.white : AppTheme().gray400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => ref.read(soilplantOrMedical.notifier).state = (ref.read(soilplantOrMedical).$1 ,1),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        color: ref.read(soilplantOrMedical).$2 == 1 ? AppTheme().orange : AppTheme().orangeLight,
                        child: Text(
                          "OfferPage.Complaint".translate(context),
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: ref.read(soilplantOrMedical).$2 == 1 ?
                              Colors.white : AppTheme().gray400,
                          ),
                        ),
                      ),
                    ),
                  )
                ] 
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.maxFinite,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme().gray700Theme(context),
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: (val) async {
                  await _submitOffer(context, ref, val);
                },
                style: Theme.of(context).textTheme.bodySmall,
                expands: true,
                maxLines: null,
                minLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: context.isDarkMode ? AppTheme().gray300 : AppTheme().gray500,
                  ),
                  hintText: "OfferPage.Comments".translate(context),
                  contentPadding: EdgeInsets.all(10),
                ),
              )
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: GestureDetector(
                    onTap: () async {
                      await _submitOffer(context, ref, _controller.text);
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme().orange,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "OfferPage.Submit".translate(context),
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ) 
            ,)
          ],
        ),
      ));
  }

  Future<void> _submitOffer(BuildContext context, WidgetRef ref, String description) async {
    if (description.trim().isEmpty) {
      _showSnackBar(context, "OfferPage.CommentError".translate(context));
      return;
    }
    _isloading = true;
    setState(() {});
    
    try {
      final String subject = ref.read(soilplantOrMedical).$2 == 0
          ? "OfferPage.Suggestion".translate(context)
          : "OfferPage.Complaint".translate(context);

      final String emailTo = ref.read(soilplantOrMedical).$1 == 0
          ? 'support@example.com'
          : 'medical-support@example.com';

      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) {
        _showSnackBar(context, "OfferPage.CancelErrorMessage".translate(context));
        return;
      }

      debugPrint('OffersScreen: would send "$subject" to $emailTo from ${user.fullName}');
      _showSnackBar(context, "OfferPage.SuccessMessage".translate(context));
    } catch (e) {
      _showSnackBar(context, "OfferPage.CancelErrorMessage".translate(context));
    }
    _isloading = false;
    setState(() {});
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}


final soilplantOrMedical = StateProvider<(int, int)>((ref) => (0,0));