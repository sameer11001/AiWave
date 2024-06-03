import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/text_theme.dart';
import '../../../data/model/user_model.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/user_image_widget.dart';
import '../controllers/home_controller.dart';

class HomeAppBar extends GetView<HomeController>
    implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  const HomeAppBar({super.key, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: CustomButton(
        icons: Icons.menu,
        width: 35,
        height: 35,
        tooltip: 'open_drawer'.tr,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        backgroundColor: Colors.grey.withOpacity(.2),
        foregroundColor: Colors.grey,
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      centerTitle: true,
      title: Obx(
        () => Text(
          '${"hi".tr}, ${UserAccount.currentUser?.username?.split(' ')[0] ?? 'user'.tr}! 👋',
          style: AppStyle.bodyText2.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      bottom: bottom,
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: UserImageWidget(),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
