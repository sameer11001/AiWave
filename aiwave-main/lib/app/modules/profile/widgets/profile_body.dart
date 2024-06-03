import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/user_model.dart';
import '../../../global_widgets/custom_list_tile.dart';
import 'custom_profile_header.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        const SizedBox(height: kToolbarHeight + 20),
        const CustomProfileHeader(),
        const SizedBox(height: 20),
        Obx(() {
          return CustomListTile(
            title: 'username'.tr,
            subtitle: UserAccount.currentUser?.username ?? '--:--',
            icons: Icons.person,
          );
        }),
        Obx(() {
          return CustomListTile(
            title: 'age'.tr,
            subtitle: UserAccount.currentUser?.age?.toString() ?? '--:--',
            icons: Icons.numbers,
          );
        }),
        SizedBox(height: Get.height * .1),
      ],
    );
  }
}
