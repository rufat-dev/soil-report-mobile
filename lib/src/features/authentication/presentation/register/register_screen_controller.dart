import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/exceptions/app_exception.dart';
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
    final normalizedFullName = fullName.trim();
    final normalizedEmail = email.trim();
    final normalizedPassword = password.trim();
    final normalizedPhoneNumber = _normalizeAzerbaijaniPhone(phoneNumber);

    _validateRegistrationInput(
      fullName: normalizedFullName,
      email: normalizedEmail,
      password: normalizedPassword,
      phoneNumber: normalizedPhoneNumber,
    );

    final auth = ref.read(authRepositoryProvider);
    await auth.registerWithEmailPassword(normalizedEmail, normalizedPassword);
    await auth.bootstrapUser(
      fullName: normalizedFullName,
      phoneNumber: normalizedPhoneNumber,
    );
    state = const AsyncValue.data(null);
  }

  void _validateRegistrationInput({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) {
    if (fullName.isEmpty) {
      throw EmptyFullNameException();
    }
    if (fullName.length < 3) {
      throw InvalidFullNameException();
    }

    if (email.isEmpty) {
      throw EmptyEmailException();
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      throw InvalidEmailFormatException();
    }

    if (password.length < 8) {
      throw PasswordInvalidException();
    }

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    if (!hasLetter || !hasDigit) {
      throw PasswordInvalidException();
    }

    if (phoneNumber.isEmpty) {
      throw EmptyPhoneNumberException();
    }
    if (!RegExp(r'^\+994\d{9}$').hasMatch(phoneNumber)) {
      throw InvalidPhoneNumberFormatException();
    }
  }

  String _normalizeAzerbaijaniPhone(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '';
    if (digits.startsWith('994') && digits.length == 12) {
      return '+$digits';
    }
    if (digits.startsWith('0') && digits.length == 10) {
      return '+994${digits.substring(1)}';
    }
    if (digits.length == 9) {
      return '+994$digits';
    }
    return value.trim();
  }
}