import 'package:flutter/material.dart';

class SystemHelper {
  static void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
