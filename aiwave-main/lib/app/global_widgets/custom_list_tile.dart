import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wave_ai/wave_ai.dart';

import '../core/theme/text_theme.dart';
import '../core/utils/helpers/custom_bottom_sheet.dart';
import '../modules/aysel_wave/views/markdown_view.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icons;

  final void Function()? onTap;
  const CustomListTile({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.icons,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        child: ListTile(
          title: Text(
            title,
            style: AppStyle.headLine5,
          ),
          subtitle: Text(
            subtitle,
            style: AppStyle.subTitle3,
          ),
          leading: Icon(icons),
          trailing: onTap != null
              ? const Icon(Icons.arrow_forward, color: Colors.grey)
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}

class WaveTile extends StatelessWidget {
  final IconData icons;
  final String title;
  final String url;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onDownlodTap;
  const WaveTile({
    super.key,
    required this.icons,
    required this.title,
    this.color,
    this.onTap,
    required this.url,
    this.onDeleteTap,
    this.onDownlodTap,
  });

  void openWaveAction() {
    CustomBottomSheet.waveAction(
      icons: icons,
      title: title,
      color: color,
      fileurl: url,
      onDeleteTap: onDeleteTap,
      onDownlodTap: onDownlodTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListTile(
        // style: ListTileStyle.drawer,
        tileColor: isDarkMode
            ? const Color(0xff171717)
            : const Color.fromARGB(255, 202, 202, 202),
        contentPadding: const EdgeInsets.all(6.0),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: color ?? Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: Icon(
            icons,
            color: Colors.black,
          ),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppStyle.bodyText2,
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.more_vert,
          ),
          onPressed: openWaveAction,
        ),
        onTap: onTap,
      ),
    );
  }
}

class ResearchItem extends StatelessWidget {
  final ResearchDocs doc;
  final bool enableBorder;
  const ResearchItem({
    super.key,
    required this.doc,
    this.enableBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final title = doc.fileName.split('.').first.replaceAll('_', ' ');
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background.withOpacity(0.4),
        border: enableBorder
            ? Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
              )
            : null,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        leading: Icon(
          FontAwesomeIcons.file,
          color: Get.theme.colorScheme.primary,
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        onTap: () => MarkdownView.show(doc: doc),
      ),
    );
  }
}
