// Importing the Flutter Secure Storage package, which provides a secure storage for sensitive data.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A class representing a local database for managing user data securely.
abstract class LocalDatabase {
  /// Instance of FlutterSecureStorage for secure storage operations.
  static const FlutterSecureStorage _box = FlutterSecureStorage();

  /// Asynchronously sets the user UID in the local database.
  ///
  /// Parameters:
  ///   - value: The user UID to be stored.
  ///
  /// Usage:
  /// ```dart
  /// await LocalDatabase.setUserUid('user123');
  /// ```
  static Future<void> setUserUid(String? value) async {
    // Using FlutterSecureStorage to write the user UID with the specified key.
    await _box.write(key: 'user_uid', value: value);
  }

  /// Asynchronously retrieves the user UID from the local database.
  ///
  /// Returns:
  ///   - The user UID stored in the local database, or null if not found.
  ///
  /// Usage:
  /// ```dart
  /// String? userUid = await LocalDatabase.getUserUid();
  /// ```
  static Future<String?> getUserUid() async {
    // Using FlutterSecureStorage to read the user UID with the specified key.
    return await _box.read(key: 'user_uid');
  }

  /// Asynchronously checks if a user is logged in by verifying the presence of a user UID.
  ///
  /// Returns:
  ///   - True if a user is logged in, false otherwise.
  ///
  /// Usage:
  /// ```dart
  /// bool isLoggedIn = await LocalDatabase.isUserLoggedIn();
  /// ```
  static Future<bool> isUserLoggedIn() async {
    // Retrieving the user UID from the local database.
    final uid = await getUserUid();
    // Checking if the user is logged in by verifying the presence of the user UID.
    return uid != null;
  }
}
