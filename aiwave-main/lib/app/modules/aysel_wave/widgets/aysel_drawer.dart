// ignore_for_file: unused_element, deprecated_member_use
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../core/theme/text_theme.dart';
import '../../../data/model/user_model.dart';
import '../../../global_widgets/custom_list_tile.dart';
import '../../../global_widgets/logo_widget.dart';
import '../../../global_widgets/wave_background.dart';

class ReserachDrawer extends StatefulWidget {
  const ReserachDrawer({super.key});

  @override
  State<ReserachDrawer> createState() => _ReserachDrawerState();
}

class _ReserachDrawerState extends State<ReserachDrawer> {
  @override
  Widget build(BuildContext context) {
    final isltr = Directionality.of(context) == TextDirection.ltr;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      width: Get.width * .7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: isltr ? const Radius.circular(20) : Radius.zero,
          bottomRight: isltr ? Radius.zero : const Radius.circular(20),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            SizedBox(
              height: Get.height * .2,
              // ignore: sort_child_properties_last
              child: Column(
                children: [
                  SizedBox(height: Get.height * .03),
                  Column(
                    children: [
                      LogoWidget(
                        margin: 5,
                        height: Get.height * .1,
                        width: Get.height * .1,
                      ),
                      Text(
                        "reserach_docs".tr,
                        style: AppStyle.headLine2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            Expanded(
              child: WaveBackground(
                child: Obx(
                  () {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: UserAccount.archiveList.length,
                      itemBuilder: (context, index) {
                        final doc = UserAccount.archiveList[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ResearchItem(
                            doc: doc,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
