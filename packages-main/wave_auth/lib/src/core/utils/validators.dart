import 'dart:developer';

abstract class WaveValidator {
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter_phone_number';
    }

    log('phone number: $value');

    final regexp = RegExp(r'^07\d{8}$');
    if (!regexp.hasMatch(value)) {
      return 'enter_valid_phone_number';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value != null && value.isEmpty) {
      return 'enter_user_name';
    }
    if (value != null && value.length > 20) {
      return 'user_name_must_be_less_than_20_characters';
    }
    final regexp = RegExp(r'^[a-zA-Z ]+$');
    if (value != null && !regexp.hasMatch(value)) {
      return 'enter_valid_user_name';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value != null && value.isEmpty) {
      return 'enter_age';
    }
    final regexp = RegExp(r'^[0-9]+$');
    if (value != null && !regexp.hasMatch(value)) {
      return 'enter_valid_age';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Please enter your email address";
    }
    if (!RegExp("^[a-zA-Z0-9+_.-]+@wave.com").hasMatch(value)) {
      return "Enter a valid email address. e.g. user@wave.com";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value != null && value.isEmpty) {
      return "This field must be filled out";
    } else if (value != null && value.length < 8) {
      return "Password must be longer than 8 characters";
    }
    return null;
  }

  static String? confirmPassword(String? v1, String? v2) {
    if (v1 != null && v1 != v2) {
      return "The password does not match";
    } else if (v1 != null && v1.isEmpty) {
      return "This field must be filled out";
    } else if (v1 != null && v1.length < 8) {
      return "Password must be longer than 8 characters";
    }
    return null;
  }

  static String? requred(String? value) {
    if (value != null && value.isEmpty) {
      return 'required_field';
    }
    return null;
  }
}
