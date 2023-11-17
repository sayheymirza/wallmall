import 'package:flutter/material.dart';
import 'package:wallmall/core/ad.dart';
import 'package:wallmall/core/database.dart';
import 'package:wallmall/models/wallpaper.dart';
import 'package:wallmall/widgets/wallpaper.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  List<Widget> widgets = [];
  int page = 1;
  bool loading = true;
  int count = 0;

  @override
  void initState() {
    super.initState();

    ad.init();

    // after the widget is created, we can access the arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      database.listFavorites().then((value) {
        setState(() {
          count = value.length;
          loading = false;
          widgets = [
            grid(
              wallpapers: value,
            ),
          ];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // on scroll to bottom load more
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          header(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ...widgets,
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      expandedHeight: 200,
      collapsedHeight: 160,
      pinned: true,
      flexibleSpace: Column(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 24,
              ),
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "My favorites",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    count == 0
                        ? loading
                            ? ""
                            : "You don't have any favorites"
                        : "$count wallpapers you have favorited",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget grid({
    List<WallpaperModel> wallpapers = const [],
  }) {
    // grid view of wallpapers
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 24,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: wallpapers.length,
      itemBuilder: (_, index) {
        return WallpaperWidget(
          wallpaper: wallpapers[index],
        );
      },
    );
  }
}
