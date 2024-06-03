import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wave_storage/wave_storage.dart';

import 'cached_network_image_util.dart';

class MediaCard extends StatefulWidget {
  final AIMedia media;
  final Future<void> Function()? onPressed;
  const MediaCard({
    super.key,
    required this.media,
    this.onPressed,
  });

  @override
  State<MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Theme.of(context).cardColor,
      disabledColor: Theme.of(context).cardColor,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: widget.onPressed == null || isLoading
          ? null
          : () async {
              setState(() => isLoading = true);
              try {
                await widget.onPressed?.call().whenComplete(() => null);
              } catch (_) {}
              setState(() => isLoading = false);
            },
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.media.thumbnailUrl ?? '',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  progressIndicatorBuilder: (context, url, download) {
                    return LoadingLogo(download: download);
                  },
                  errorWidget: (context, url, error) {
                    return const ErrorNetworkWidget();
                  },
                ),
                if (isLoading)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const SizedBox(
                        height: 12.0,
                        width: 12.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).cardColor,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.media.fileName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
