const String emailRegexString =
    r"^[a-zA-Z0-9.!#$%&'*+\-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$";

const String passwordRegexString = r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d@]{6,}$';

const String usernameRegexString = r'^[a-zA-Z0-9,.-]+$';

abstract final class ValidatorApp {
  ValidatorApp._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email cannot be empty';
    }

    final email = value.trim();
    final emailRegex = RegExp(emailRegexString);

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }

    final passwordRegex = RegExp(passwordRegexString);

    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain at least 6 characters, one uppercase letter, and one number';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password cannot be empty';
    }

    if (value != password) {
      return 'Confirm password must match the password';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number cannot be empty';
    }

    final phone = value.trim();

    final phoneRegex = RegExp(r'^\+?\d{10,15}$');

    if (!phoneRegex.hasMatch(phone)) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  static String? validateCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Code cannot be empty';
    }

    final code = value.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      return 'Code must be exactly 6 digits';
    }

    return null;
  }
}
