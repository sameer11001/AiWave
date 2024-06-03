import 'package:get/get.dart';
import 'package:wave_auth/wave_auth.dart';

import '../../core/utils/helpers/custom_logs.dart';
import '../../routes/app_pages.dart';
import '../model/user_model.dart';

abstract class AuthRepository extends GetxService {
  static final waveAuth = WaveAuth.instance;

  /// Signs in a user.
  ///
  /// Returns a [Future<User>] that resolves to the signed in user.
  static Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final User user = await waveAuth.signIn(
        email: email,
        password: password,
      );

      return user;
    } on WaveAuthException catch (error) {
      logError(error.toString());
      rethrow;
    }
  }

  /// Signs up a user.
  ///
  /// Returns a [Future<User>] that resolves to the signed up user.
  static Future<User> signUp({
    required String email,
    required String password,
    String? username,
    int? age,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      final User user = await waveAuth.signUp(
        email: email,
        password: password,
        username: username,
        age: age,
        imageUrl: imageUrl,
        data: data,
      );

      return user;
    } on WaveAuthException catch (error) {
      logError(error.toString());
      rethrow;
    }
  }

  /// Signs out the current user.
  ///
  /// Returns a [Future<void>] that resolves when the user is signed out.
  static Future<void> signOut() async {
    try {
      await waveAuth.signOut();
      // Go to the sign in view
      Get.offAllNamed(Routes.SIGNIN)?.then((value) {
        // Set the current user to null
        UserAccount.currentUser = null;
        UserAccount.mediaList.clear();
        UserAccount.archiveList.clear();
      },);
    } on WaveAuthException catch (error) {
      logError(error.toString());
    }
  }

  /// updates the current user.
  ///
  /// Returns a [Future<User>] that resolves to the updated user.
  static Future<User> updateCurrentUser({
    String? username,
    int? age,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      final User user = await waveAuth.updateUser(
        username: username,
        age: age,
        imageUrl: imageUrl,
        data: data,
      );

      return user;
    } on WaveAuthException catch (error) {
      logError(error.toString());
      rethrow;
    }
  }
}
