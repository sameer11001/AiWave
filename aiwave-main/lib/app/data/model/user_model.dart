import 'package:get/get.dart';
import 'package:wave_ai/wave_ai.dart';
import 'package:wave_auth/wave_auth.dart';
import 'package:wave_storage/wave_storage.dart';

class UserAccount extends GetxController {
  static final Rx<User?> _currentUser = WaveAuth.instance.currentUser.obs;

  static User? get currentUser => _currentUser.value;
  static set currentUser(User? user) => _currentUser.value = user;

  static final RxList<AIMedia> _mediaList = RxList.empty();

  static List<AIMedia> get mediaList => _mediaList;
  static set mediaList(List<AIMedia> value) => _mediaList.value = value;

  static final RxList<ResearchDocs> _archiveList = RxList.empty();

  static List<ResearchDocs> get archiveList => _archiveList;
  static set archiveList(List<ResearchDocs> value) => _archiveList.value = value;


  static Future<void> init() async {
    Get.put(UserAccount());

    await _bindUserChanges();
    mediaList = await currentUser!.getMedia();
    archiveList = await currentUser!.getArchive();
  }

  static Future<void> _bindUserChanges() async {
    WaveAuth.instance.onUserChanged.listen((user) {
      if (user != null) {
        // Update the user
        currentUser = user;
      } else {
        // User signed out
      }
    });
  }
}

extension UserAccountExtension on User {
  bool get isAdmin => role == UserRole.admin;
}
