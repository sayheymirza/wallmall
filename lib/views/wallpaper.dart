import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallmall/api/api.dart';
import 'package:wallmall/core/connectivity.dart';
import 'package:wallmall/core/database.dart';
import 'package:wallmall/core/hex.dart';
import 'package:wallmall/dialogs/wallpaper.dart';
import 'package:wallmall/models/wallpaper.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallmall/widgets/loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WallpaperView extends StatefulWidget {
  const WallpaperView({super.key});

  @override
  State<WallpaperView> createState() => _WallpaperViewState();
}

class _WallpaperViewState extends State<WallpaperView> {
  WallpaperModel? wallpaper;
  bool downloading = false;
  bool favorite = false;

  // scafold key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // wait for the widget to be ready
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ignore: no_leading_underscores_for_local_identifiers
      var _wallpaper =
          ModalRoute.of(context)!.settings.arguments as WallpaperModel;

      database.hasFavorite(_wallpaper).then((value) {
        setState(() {
          favorite = value;
        });
      });

      if (await connectivity.connected) {
        api.wallpaper(id: _wallpaper.id).then((value) {
          if (value == null) {
            Navigator.pop(context);
          } else {
            setState(() {
              wallpaper = value;
            });
          }
        });
      } else {
        database.getWallpaper(_wallpaper.id).then((value) {
          if (value == null) {
            Navigator.pop(context);
          } else {
            setState(() {
              wallpaper = value;
            });
          }
        });
      }
    });
  }

  void setAsWallpaper() {
    if (wallpaper != null) {
      _scaffoldKey.currentState!.showBottomSheet(
        (context) => WallpaperDialog(
          image: wallpaper!.image,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
    }
  }

  void download() {
    if (wallpaper != null && !downloading) {
      setState(() {
        downloading = true;
      });

      http.get(Uri.parse(wallpaper!.image)).then((response) {
        if (response.statusCode == 200) {
          // ignore: avoid_print
          print("Downloaded");

          ImageGallerySaver.saveImage(
            response.bodyBytes,
            name: wallpaper!.name ?? "wallpaper",
          );

          setState(() {
            downloading = false;
          });
        }
      });
    }
  }

  void share() {
    if (wallpaper != null) {
      print("Share");

      // download the image and share it as xfile
      http.get(Uri.parse(wallpaper!.image)).then((response) async {
        if (response.statusCode == 200) {
          // ignore: avoid_print
          print("Downloaded");

          // file path to save the image share.jpg
          String path = "${(await getTemporaryDirectory()).path}/share.jpg";

          // write the image to a file
          File file = File(path);
          await file.writeAsBytes(response.bodyBytes);

          var text = wallpaper!.name ?? 'wallpaper';

          if (wallpaper!.tags.isNotEmpty) {
            text += "\n";

            for (var tag in wallpaper!.tags) {
              text += "#${tag.text} ";
            }
          }

          text += "\n";
          text += "Wallpaper from #WallMall";

          // share the image
          Share.shareFiles(
            [path],
            text: text,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Setting SysemUIOverlay
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: true,
        systemNavigationBarColor: Colors.white.withOpacity(0.1),
        systemNavigationBarDividerColor: Colors.white.withOpacity(0.1),
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white.withOpacity(0.1),
      ),
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: wallpaper != null
              ? Text(
                  wallpaper!.name ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const LoadingWidget(
                  width: 120,
                  height: 28,
                ),
          actions: [
            // favorite button
            IconButton(
              onPressed: () {
                if (wallpaper != null) {
                  if (favorite) {
                    database.removeFromFavorite(wallpaper!);
                  } else {
                    database.addToFavorite(wallpaper!);
                  }

                  setState(() {
                    favorite = !favorite;
                  });
                }
              },
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? Colors.red : null,
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: wallpaper != null
                    ? CachedNetworkImage(
                        imageUrl: wallpaper!.image,
                        fit: BoxFit.cover,
                      )
                    : const LoadingWidget(
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
            ),
            // download button
            Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (wallpaper != null && wallpaper!.description != null)
                    Text(
                      wallpaper!.description!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  // tags
                  if (wallpaper != null && wallpaper!.tags.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: wallpaper!.tags
                          .map(
                            (tag) => Text(
                              "#${tag.text}",
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      // download button
                      IconButton(
                        onPressed: () {
                          if (wallpaper == null) return;
                          download();
                        },
                        icon: const Icon(
                          Icons.download,
                        ),
                      ),
                      // share button
                      IconButton(
                        onPressed: () {
                          if (wallpaper == null) return;

                          share();
                        },
                        icon: const Icon(
                          Icons.share,
                        ),
                      ),
                      const Spacer(),
                      // flat button
                      ElevatedButton.icon(
                        onPressed: () {
                          if (wallpaper == null) return;

                          setAsWallpaper();
                        },
                        icon: const Icon(Icons.wallpaper),
                        label: Text(
                          AppLocalizations.of(context)!.setAsWallpaper,
                        ),
                        style: ElevatedButton.styleFrom(
                          surfaceTintColor: Colors.white,
                          backgroundColor:
                              wallpaper == null || wallpaper!.colors.isEmpty
                                  ? Theme.of(context).colorScheme.primary
                                  : HexColor(
                                      wallpaper!.colors[0].value,
                                    ),
                          foregroundColor:
                              wallpaper != null && wallpaper!.colors.isNotEmpty
                                  ? wallpaper!.colors[0].value == "#ffffff"
                                      ? Colors.black
                                      : Colors.white
                                  : Colors.white,
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
