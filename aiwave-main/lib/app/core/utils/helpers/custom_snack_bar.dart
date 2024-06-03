// ignore_for_file: unused_local_variable

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave_auth/wave_auth.dart';

abstract class CustomSnackBar {
  static void defaultSnackBar({
    String? title,
    required String message,
    ContentType? contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title?.tr ?? '',
        message: message,
        contentType: contentType ?? ContentType.help,
      ),
    );

    ScaffoldMessenger.of(Get.overlayContext!)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void error({
    String? title = 'error',
    required String message,
  }) {
    defaultSnackBar(
      title: title,
      message: message,
      contentType: ContentType.failure,
    );
  }

  static void warning({
    String? title = 'Warning',
    required String message,
  }) {
    defaultSnackBar(
      title: title,
      message: message,
      contentType: ContentType.warning,
    );
  }

  static void success({
    String? title = 'Success',
    required String message,
  }) {
    defaultSnackBar(
      title: title,
      message: message,
      contentType: ContentType.success,
    );
  }

  static void waveAuthException(WaveAuthException error) {
    String errorMessage;
    switch (error.code) {
      case 'user-not-found':
        errorMessage = 'user_not_found'.tr;
        break;
      case 'user-disabled':
        errorMessage = 'user_disabled'.tr;
        break;
      case 'invalid-email':
        errorMessage = 'invalid_email'.tr;
        break;
      case 'wrong-password':
        errorMessage = 'wrong_password'.tr;
        break;
      case 'email-already-in-use':
        errorMessage = 'email_already_in_use'.tr;
        break;
      case 'weak-password':
        errorMessage = 'weak_password'.tr;
        break;
      case 'invalid_email_or_password':
        errorMessage = 'invalid_email_or_password'.tr;
        break;
      case 'validation_error':
        errorMessage = 'validation_error'.tr;
        break;
      default:
        errorMessage = "Error";
    }

    CustomSnackBar.error(
      title: error.code.replaceAll('_', '-').camelCase,
      message: error.message,
    );
  }
}
