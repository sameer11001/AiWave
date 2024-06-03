// ignore_for_file: unnecessary_getters_setters

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:wave_auth/src/data/model/user_process.dart';
import 'package:wave_storage/wave_storage.dart';

import '../../../wave_auth.dart';
import '../../core/utils/helpers/custom_logs.dart';
import '../apis/auth_api.dart';
import '../apis/users_api.dart';
import '../database/local_database.dart';

class WaveAuth {
  static late final WaveAuth instance;

  final AuthAPI authAPI;
  final UsersAPI usersAPI;
  User? _user;
  WaveAuth({
    required this.authAPI,
    required this.usersAPI,
    User? user,
  }) : _user = user;

  // Stream controller to notify listeners when the user changes
  final _userController = StreamController<User?>.broadcast();

  // Stream getter for external classes to listen for user changes
  Stream<User?> get onUserChanged => _userController.stream;

  User? get currentUser => _user;
  set currentUser(User? user) {
    _user = user;
    LocalDatabase.setUserUid(user?.uid);

    // Notify listeners that the user has changed
    _userController.add(user);
  }

  static Future<void> init() async {
    // Initialize the WaveAuthService instance.
    instance = WaveAuth(
      authAPI: AuthAPI(),
      usersAPI: UsersAPI(),
    );

    // Check if the user is already signed in.
    final uid = await LocalDatabase.getUserUid();
    if (uid != null) {
      try {
        // Get the user from the server.
        final User user = await instance.getUser(uid: uid);

        logInfo('Signed in as `${user.uid}`.');

        // Set the current user.
        instance.currentUser = user;
      } catch (e) {
        logError(e.toString());
      }
    }
  }

  /// Checks if the server is running.
  ///
  /// Returns a [Future<Map<String, dynamic>>] containing the server response.
  Future<Map<String, dynamic>> checkServer() async {
    try {
      final Response response = await authAPI.checkServer();

      switch (response.statusCode) {
        case 200:
          return response.data as Map<String, dynamic>;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAuthException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to check server.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Signs in a user.
  ///
  /// Returns a [Future<User>] containing the server response.
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final Response response = await authAPI.signIn(email, password);

      switch (response.statusCode) {
        case 200:
          final data = response.data['user'] as Map<String, dynamic>;
          User user = User.fromMap(data);

          // Set the current user.
          instance.currentUser = user;

          return user;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAuthException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to sign in.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Signs up a user.
  ///
  /// Returns a [Future<User>] containing the server response.
  Future<User> signUp({
    required String email,
    required String password,
    String? username,
    int? age,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      final Response response = await authAPI.signUp(email, password,
          username: username, age: age, imageUrl: imageUrl, data: data);

      switch (response.statusCode) {
        case 200:
          final data = response.data['user'] as Map<String, dynamic>;
          User user = User.fromMap(data);

          // Set the current user.
          instance.currentUser = user;

          return user;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAuthException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to sign up.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Signs out the current user.
  ///
  /// Returns a [Future<void>] containing the server response.
  Future<void> signOut() async {
    try {
      // Set the current user to null.
      instance.currentUser = null;
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Gets a user by uid.
  ///
  /// Returns a [Future<User>] containing the server response.
  Future<User> getUser({
    required String uid,
  }) async {
    try {
      final Response response = await usersAPI.getUser(uid);

      switch (response.statusCode) {
        case 200:
          final data = response.data['user'] as Map<String, dynamic>;
          User user = User.fromMap(data);
          return user;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAuthException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to get user.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Updates the user.
  ///
  /// Returns a [Future<User>] containing the server response.
  Future<User> updateUser({
    String? username,
    int? age,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      final Response response = await usersAPI.updateUser(
        instance.currentUser!.uid,
        username: username,
        age: age,
        imageUrl: imageUrl,
        data: data,
      );

      switch (response.statusCode) {
        case 200:
          final data = response.data['user'] as Map<String, dynamic>;
          User user = User.fromMap(data);

          // Set the current user.
          instance.currentUser = user;

          return user;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAuthException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to update user.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Get all the user media.
  ///
  /// Returns a [Future<List<AIMedia>>] containing the server response.
  Future<List<AIMedia>> getUserMedia({
    required String userUid,
  }) async {
    try {
      final Response response = await usersAPI.getUserAttributes(
        userUid,
        'media',
      );

      switch (response.statusCode) {
        case 200:
          final data = response.data['data'] as List<dynamic>;
          List<AIMedia> media = data.map((e) => AIMedia.fromMap(e)).toList();
          return media;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAuthException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to get user media.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Get Process by mediaUid
  ///
  /// Returns a [Future<Process>] containing the server response.
  Future<List<UserProcess>> getProcessByMediaUid({
    required String uid,
    required String mediaUid,
  }) async {
    try {
      final Response response = await usersAPI.getProcessByMediaUid(
        uid,
        mediaUid,
      );
      switch (response.statusCode) {
        case 200:
          final data = response.data['data'] as List<dynamic>;
          List<UserProcess> processList = data
              .map((e) => UserProcess.fromMap(e as Map<String, dynamic>))
              .toList();

          return processList;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAuthException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to get user media.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  Future<UserProcess> getProcessesByProcessUid({
    required String uid,
    required String mediaUid,
    required String processUid,
  }) async {
    try {
      final Response response = await usersAPI.getProcessesByProcessUid(
        uid,
        processUid,
        mediaUid,
      );
      switch (response.statusCode) {
        case 200:
          final data = response.data['data'] as Map<String, dynamic>;
          final process = UserProcess.fromMap(data);

          return process;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAuthException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to get user media.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Deletes a user.
  ///
  /// Returns a [Future<String>] containing message the server response.
  Future<String> deleteMedia(
      {required String uid, required String mediaUid}) async {
    try {
      // Send a DELETE request to the server and await the response.
      final Response response = await usersAPI.deleteMedia(uid, mediaUid);
      switch (response.statusCode) {
        case 200:
          final message = response.data['message'] as String;
          return message;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAuthException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to get user media.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  /// Delete Process By ProcessUid
  ///
  /// Returns a [Future<String>] containing message the server response.
  Future<String> deleteProcessByProcessUid(
      {required String uid,
      required String mediaUid,
      required String processUid}) async {
    try {
      // Send a DELETE request to the server and await the response.
      final Response response =
          await usersAPI.deleteProcessByProcessUid(uid, mediaUid, processUid);
      switch (response.statusCode) {
        case 200:
          final message = response.data['message'] as String;
          return message;
        default:
          if (response.data is Map<String, dynamic>) {
            throw WaveAuthException.fromRespone(response);
          }
          throw Exception('[${response.statusCode}].Failed to get user media.');
      }
    } catch (e) {
      logError(e.toString());
      rethrow; // Rethrow the exception to propagate it further if needed.
    }
  }

  // Close the stream controller when the service is disposed
  void dispose() {
    _userController.close();
  }
}
