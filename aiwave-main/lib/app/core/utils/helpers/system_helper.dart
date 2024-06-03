import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SystemHelper {
  static void makeCall(String phoneNumber) {
    try {
      launchUrl(Uri.parse("tel://$phoneNumber"));
    } catch (e) {
      if (kDebugMode) {
        print("error when make a call: $e");
      }
    }
  }

  static void makeMessage({required String phoneNumber, String message = ''}) {
    final Uri uri = Uri.parse('sms:$phoneNumber?body=$message');
    try {
      launchUrl(uri);
    } catch (e) {
      if (kDebugMode) {
        print("Could not launch messaging app: $e");
      }
    }
  }

  static void openUrl(String url) {
    try {
      launchUrl(Uri.parse(url));
    } catch (e) {
      if (kDebugMode) {
        print("Could not launch $url: $e");
      }
    }
  }

  static void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
