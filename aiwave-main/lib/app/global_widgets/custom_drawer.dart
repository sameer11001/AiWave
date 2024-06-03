// ignore_for_file: unused_element, deprecated_member_use

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/helpers/custom_dialog.dart';
import '../data/database/local_database.dart';
import '../data/model/user_model.dart';
import '../routes/app_pages.dart';
import 'user_image_widget.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width * .7,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            // decoration: const BoxDecoration(color: Colors.orange),
            currentAccountPicture: UserImageWidget(
              size: Get.height * .08,
              onTap: () {
                // Close the drawer
                Get.back();
                // Navigate to profile page
                Get.toNamed(Routes.PROFILE);
              },
            ),
            accountName: Text(
              UserAccount.currentUser?.username?.capitalize ?? "User Name",
              style: TextStyle(
                color: Get.theme.colorScheme.background,
              ),
            ),
            accountEmail: Text(
              UserAccount.currentUser?.email ?? "user@example.com",
              style: TextStyle(
                color: Get.theme.colorScheme.background,
              ),
            ),
            otherAccountsPictures: [
              ThemeSwitcher.withTheme(
                builder: (context, switcher, theme) {
                  final isDarkMode = theme.brightness == Brightness.dark;
                  return IconButton(
                    onPressed: () async {
                      await LocalDatabase.setTheme(!isDarkMode);
                      switcher.changeTheme(
                        theme: isDarkMode ? AppTheme.light : AppTheme.dark,
                      );
                    },
                    tooltip: isDarkMode ? "light_mode".tr : "dark_mode".tr,
                    splashRadius: 25.0,
                    icon: Icon(
                      isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
                    ),
                    color: isDarkMode ? Colors.grey : Colors.grey,
                  );
                },
              )
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  title: 'language'.tr,
                  icons: FontAwesomeIcons.language,
                  onTap: () {
                    CustomDialog.changeLanguage();
                  },
                ),
                const Divider(),
                _DrawerItem(
                  title: 'rate_us'.tr,
                  icons: Icons.rate_review,
                  enabled: false,
                ),
                _DrawerItem(
                  title: 'about_us'.tr,
                  icons: Icons.people,
                  enabled: false,
                ),
                const Divider(),
                _DrawerItem(
                  title: 'sign_out'.tr,
                  icons: FontAwesomeIcons.rightFromBracket,
                  onTap: () async {
                    await CustomDialog.showSignOutDialog();
                  },
                ),
                _DrawerItem(
                  title: 'settings'.tr,
                  icons: Icons.settings,
                  enabled: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final String? subTitle;
  final IconData icons;
  final String? viewNamed;
  final bool enabled;
  final Function()? onTap;
  final Widget? trailing;

  const _DrawerItem({
    required this.title,
    required this.icons,
    this.enabled = true,
    this.subTitle,
    this.viewNamed,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: enabled ? "" : 'coming_soon'.tr,
      child: ListTile(
        leading: Icon(icons),
        enabled: enabled,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        subtitle: subTitle != null ? Text(subTitle!) : null,
        onTap: onTap ??
            () {
              Get.back();
              if (viewNamed != null) {
                Get.toNamed(viewNamed!);
              }
            },
        trailing: enabled ? trailing ?? const SizedBox() : Text("soon".tr),
      ),
    );
  }
}
