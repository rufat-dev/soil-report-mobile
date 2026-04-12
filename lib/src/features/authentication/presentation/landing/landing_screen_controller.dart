import 'package:soilreport/src/exceptions/app_exception.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/utils/extensions/uri_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'landing_screen_controller.g.dart';

@riverpod
class LandingScreenController extends _$LandingScreenController{
  @override
  FutureOr<void> build() {
    // nothing to do
  }
  Future<void> digitalLogin() async {
    final authService = ref.watch(authRepositoryProvider);
    String? asanUrl = await authService.getAsanLoginUrlAsync();
    if(asanUrl != null){
      try {
        final uri = Uri.parse(asanUrl);
        await uri.launch(mode: LaunchMode.externalApplication);
        return;
      } catch (e) {
        // Fall through to throw exception
      }
    }
    throw NetworkIssueException();
  }

}