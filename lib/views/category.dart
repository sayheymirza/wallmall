// this file show wallpapers filtered by category

import 'package:flutter/material.dart';
import 'package:wallmall/api/api.dart';
import 'package:wallmall/core/ad.dart';
import 'package:wallmall/models/category.dart';
import 'package:wallmall/models/wallpaper.dart';
import 'package:wallmall/widgets/ad.dart';
import 'package:wallmall/widgets/wallpaper.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  CategoryModel? category;
  List<Widget> widgets = [];
  int page = 1;
  bool loading = false;
  bool loadingMore = true;
  int count = 0;

  @override
  void initState() {
    super.initState();

    ad.init();

    // after the widget is created, we can access the arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: no_leading_underscores_for_local_identifiers
      category = ModalRoute.of(context)!.settings.arguments as CategoryModel;

      fetchWallpapers();
    });
  }

  Future<void> fetchWallpapers() async {
    if (loadingMore == false) {
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      var result = await api.wallpapers(
        page: page,
        category: category!.id,
      );

      setState(() {
        loading = false;
      });

      if (result == null || result.wallpapers.isEmpty) {
        setState(() {
          loadingMore = false;
        });

        return;
      }

      setState(() {
        count = result.count;
        widgets = [
          ...widgets,
          grid(
            wallpapers: result.wallpapers,
          ),
          const AdWidget(),
        ];
      });
    } catch (e) {
      print("=== ERROR ===");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: category == null
          ? Container()
          : NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (!loading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  setState(() {
                    page++;
                  });

                  print("Ended");

                  fetchWallpapers();
                }

                return true;
              },
              child: RefreshIndicator(
                backgroundColor: Colors.white,
                onRefresh: () async {
                  setState(() {
                    widgets = [];
                    page = 1;
                    loadingMore = true;
                  });

                  print("Refresh");

                  return fetchWallpapers();
                },
                child: CustomScrollView(
                  // on scroll to bottom load more
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    header(),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        widgets,
                      ),
                    ),
                  ],
                ),
              ),
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
                  Text(
                    category!.name,
                    style: const TextStyle(
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
                            : "No results for this category"
                        : "$count wallpapers for this category",
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