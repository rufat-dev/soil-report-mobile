import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:soilreport/src/core/utils/string_extension.dart';
import 'package:soilreport/src/exceptions/app_exception.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'passcode_screen_controller.g.dart';

@riverpod
class PasscodeScreenController extends _$PasscodeScreenController {

  final LocalAuthentication _biometricAuth = LocalAuthentication();

  @override
  PasscodeScreenState build() => PasscodeScreenState(
      input: '',
      checkState: null,
    );


  Future<void> updateInput(String c) async  {
    final current = state.input;
    String updated = current;
    if(c == 'f'){
      await biometrics();
    }else if (c == 'r') {
      if (current.isNotEmpty) {
        updated = current.substring(0, current.length - 1);
      }
    } else if (current.length < 4) {
      updated += c;
    }
    state = state.copyWith(input: updated, checkState:  state.checkState);
    if(updated.length == 4){
      await checkPasscode(updated);
    }
  }

    Future<bool> isFirstLogin() async {
      final storage = ref.watch(secureStorageProvider);
      final cachedPasscode = await storage.readPasscode();
      return cachedPasscode.isNullOrEmpty;
    }


    Future<bool> checkPasscode(String passcode) async {
      state = state.copyWith(input: state.input, checkState: AsyncValue.loading());
      final storage = ref.watch(secureStorageProvider);
      final cachedPasscode = await storage.readPasscode();
      if (cachedPasscode.isNullOrEmpty) {
        state = state.copyWith(input: state.input, checkState: await AsyncValue.guard(() => storage.writePasscode(passcode)));
        return !state.checkState!.hasError ;
      } else {
        if (passcode == cachedPasscode) {
          state = state.copyWith(input: state.input, checkState: const AsyncValue.data(null));
          return true;
        } else {
          state = state.copyWith(input: "", checkState: AsyncValue.error("incorrect passcode", StackTrace.current));
          return false;
        }
      }
    }
    Future biometrics() async {
      state = state.copyWith(input: state.input, checkState: AsyncValue.loading());
      state = state.copyWith(input: state.input, checkState:  await AsyncValue.guard(() async 
        {
          if(!await _biometricAuth.canCheckBiometrics){
            throw BiometricAuthenticationNotSupportedException();
          }
          try{
            final result = await _biometricAuth.authenticate(
                localizedReason: "Authenticate to log in",
                options: const AuthenticationOptions(biometricOnly: true)
            );
            if(!result){
              throw BiometricAuthenticationFailedException();
            }
            return;  

          } catch (e) {
            throw BiometricAuthenticationFailedException();
          }
        }
      ));
      return;
    }
}
class PasscodeScreenState {
  final String input;
  final AsyncValue<void>? checkState;

  const PasscodeScreenState({
    required this.input,
    required this.checkState,
  });

  PasscodeScreenState copyWith({
    String? input,
    AsyncValue<void>? checkState,
  }) {
    return PasscodeScreenState(
      input: input ?? this.input,
      checkState: checkState ?? this.checkState,
    );
  }
}