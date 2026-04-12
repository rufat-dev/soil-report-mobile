import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_screen_controller.g.dart';

@riverpod
class RegisterScreenController extends _$RegisterScreenController{
  @override
  FutureOr<void> build() {
    // nothing to do
  }
  Future<void> tryRegister(String fullName, String email, String password, String phoneNumber) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard( () => register(fullName, email, password, phoneNumber));
  }
  Future<void> register(String fullName, String email, String password, String phoneNumber) async {
    final auth = ref.read(authRepositoryProvider);
    await auth.registerWithEmailPassword(email, password);
    await auth.bootstrapUser(fullName: fullName, phoneNumber: phoneNumber);
    state = const AsyncValue.data(null);
  }
}