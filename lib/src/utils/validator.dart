class Validator {

  static bool isValidPhoneNumber (String input) {
    final regex = RegExp(r'^994\d{9}$');
    return regex.hasMatch(input);
  }
}

