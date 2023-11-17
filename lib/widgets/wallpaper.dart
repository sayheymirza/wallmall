import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallmall/models/wallpaper.dart';

class WallpaperWidget extends StatefulWidget {
  final WallpaperModel wallpaper;

  const WallpaperWidget({
    super.key,
    required this.wallpaper,
  });

  @override
  State<WallpaperWidget> createState() => _WallpaperWidgetState();
}

class _WallpaperWidgetState extends State<WallpaperWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/_/wallpaper",
          arguments: widget.wallpaper,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: CachedNetworkImageProvider(widget.wallpaper.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
