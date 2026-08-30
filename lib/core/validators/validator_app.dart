import 'package:easy_localization/easy_localization.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';

const String emailRegexString =
    r"^[a-zA-Z0-9.!#$%&'*+\-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$";

const String passwordRegexString = r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d@]{6,}$';

const String usernameRegexString = r'^[a-zA-Z0-9,.-]+$';

abstract final class ValidatorApp {
  ValidatorApp._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.emailCannotBeEmpty.tr();
    }

    final email = value.trim();
    final emailRegex = RegExp(emailRegexString);

    if (!emailRegex.hasMatch(email)) {
      return LocaleKeys.enterValidEmail.tr();
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.passwordCannotBeEmpty.tr();
    }

    final passwordRegex = RegExp(passwordRegexString);

    if (!passwordRegex.hasMatch(value)) {
      return LocaleKeys.passwordRequirements.tr();
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.confirmPasswordCannotBeEmpty.tr();
    }

    if (value != password) {
      return LocaleKeys.confirmPasswordMustMatch.tr();
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.nameCannotBeEmpty.tr();
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.phoneNumberCannotBeEmpty.tr();
    }

    final phone = value.trim();

    final phoneRegex = RegExp(r'^\+?\d{10,15}$');

    if (!phoneRegex.hasMatch(phone)) {
      return LocaleKeys.enterValidPhoneNumber.tr();
    }

    return null;
  }

  static String? validateCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.codeCannotBeEmpty.tr();
    }

    final code = value.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      return LocaleKeys.codeMustBeSixDigits.tr();
    }

    return null;
  }
}
