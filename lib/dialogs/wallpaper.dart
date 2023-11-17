import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WallpaperDialog extends StatefulWidget {
  final String image;
  final double bottom;

  const WallpaperDialog({
    super.key,
    required this.image,
    required this.bottom,
  });

  @override
  State<WallpaperDialog> createState() => _WallpaperDialogState();
}

class _WallpaperDialogState extends State<WallpaperDialog> {
  int location = AsyncWallpaper.BOTH_SCREENS;

  void apply() {
    Navigator.pop(context);

    if (location != 0) {
      AsyncWallpaper.setWallpaper(
        url: widget.image,
        wallpaperLocation: location,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: widget.bottom + 50,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // grid 2x1
          SizedBox(
            height: 300,
            child: Row(
              children: [
                Expanded(
                  child: screen(
                    title: "Lock Screen",
                    checked: location == AsyncWallpaper.LOCK_SCREEN ||
                        location == AsyncWallpaper.BOTH_SCREENS,
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          if (location == AsyncWallpaper.HOME_SCREEN) {
                            location = AsyncWallpaper.BOTH_SCREENS;
                          } else {
                            location = AsyncWallpaper.LOCK_SCREEN;
                          }
                        } else {
                          if (location == AsyncWallpaper.BOTH_SCREENS) {
                            location = AsyncWallpaper.HOME_SCREEN;
                          } else {
                            location = 0;
                          }
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: screen(
                    title: "Home Screen",
                    checked: location == AsyncWallpaper.HOME_SCREEN ||
                        location == AsyncWallpaper.BOTH_SCREENS,
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          if (location == AsyncWallpaper.LOCK_SCREEN) {
                            location = AsyncWallpaper.BOTH_SCREENS;
                          } else {
                            location = AsyncWallpaper.HOME_SCREEN;
                          }
                        } else {
                          if (location == AsyncWallpaper.BOTH_SCREENS) {
                            location = AsyncWallpaper.LOCK_SCREEN;
                          } else {
                            location = 0;
                          }
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                apply();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "Apply",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget screen({
    required String title,
    required bool checked,
    required void Function(bool) onChanged,
  }) {
    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              child: Container(
                height: 200,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        // checkbox for toggle
        const SizedBox(height: 10),
        Checkbox(
          value: checked,
          onChanged: (value) {
            onChanged(value ?? false);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
