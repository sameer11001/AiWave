import 'package:aiwave/app/data/database/image_wave.dart';
import 'package:get/get.dart';
import 'package:wave_auth/wave_auth.dart';

import '../../../core/utils/helpers/custom_bottom_sheet.dart';
import '../../../data/model/user_model.dart';

class ProfileController extends GetxController {
  final RxBool _isUpdateImage = false.obs;

  bool get isUpdateImage => _isUpdateImage.value;

  Future<void> updateUserProfile() async {
    final image = await CustomBottomSheet.imagePiker();
    if (image != null) {
      _isUpdateImage(true);

      final uid = UserAccount.currentUser!.uid;

      String? imageUrl = await StorageDatabase.uploadUserImage(
        imagePath: image.path,
        uid: uid,
      );

      await WaveAuth.instance.updateUser(imageUrl: imageUrl);

      _isUpdateImage(false);
    }
  }
}
