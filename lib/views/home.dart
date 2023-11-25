import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallmall/api/api.dart';
import 'package:wallmall/core/ad.dart';
import 'package:wallmall/core/connectivity.dart';
import 'package:wallmall/core/database.dart';
import 'package:wallmall/core/provider.dart';
import 'package:wallmall/models/category.dart';
import 'package:wallmall/models/color.dart';
import 'package:wallmall/models/wallpaper.dart';
import 'package:wallmall/widgets/ad.dart';
import 'package:wallmall/widgets/category.dart';
import 'package:wallmall/widgets/color.dart';
import 'package:wallmall/widgets/drawer.dart';
import 'package:wallmall/widgets/loading.dart';
import 'package:wallmall/widgets/search.dart';
import 'package:wallmall/widgets/wallpaper.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<WallpaperModel> wallpapers = []; // news wallpapers
  List<Widget> widgets = [];
  // new empty array 10 count
  List<Widget> loadingWidgets = List.generate(
    10,
    (index) => const LoadingWidget(
      width: double.infinity,
      height: 200,
    ),
  );
  int page = 1;
  bool loading = false;
  bool loadingMore = true;
  bool offline = false;

  // scaffold key
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    ad.init();

    fetchWallpapers();

    // listen to connectivity
    connectivity.self.onConnectivityChanged.listen((_) async {
      var result = await connectivity.connected;
      setState(() {
        offline = !result;
      });
    });
  }

  Future<void> fetchWallpapers() async {
    if (loadingMore == false) {
      return;
    }

    if (await connectivity.connected == false) {
      database.getWallpapers().then((value) {
        setState(() {
          wallpapers = value.reversed.toList();
          widgets = [];
          page = 1;
          loading = false;
          loadingMore = false;
          offline = true;
        });
      });

      return;
    }

    if (loading == true) {
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      var result = await api.wallpapers(
        page: page,
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

      if (page == 1) {
        setState(() {
          wallpapers = result.wallpapers;
        });

        database.setWallpapers(wallpapers);

        print("New wallpaper set");
      }

      setState(() {
        offline = false;

        page += 1;

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
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ShareProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: drawer(),
      body: container(
        header: header(
          onMenuTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        search: const SearchWidget(),
        children: [
          // content
          content(
            children: [
              if (wallpapers.isNotEmpty)
                title(
                  text: AppLocalizations.of(context)!.newWallpapers,
                ),
              if (wallpapers.isNotEmpty) news(wallpapers: wallpapers),
              if (provider.categories.isNotEmpty)
                title(
                  text: AppLocalizations.of(context)!.categories,
                ),
              if (provider.categories.isNotEmpty)
                categories(categories: provider.categories),
              if (provider.colors.isNotEmpty)
                title(
                  text: AppLocalizations.of(context)!.colors,
                ),
              if (provider.colors.isNotEmpty) colors(colors: provider.colors),
              ...widgets,
              if (loading) loadingrid(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom + 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget container({
    required List<Widget> children,
    required Widget search,
    List<Widget> header = const [],
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // gradiant background
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (!loading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
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
              // header
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 20,
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: header,
                      ),
                    ),
                  ],
                ),
              ),
              // app bar
              SliverAppBar(
                floating: true,
                primary: false,
                elevation: 0,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                // app bar content
                flexibleSpace: search,
                // height of app bar
                toolbarHeight: 120,
                actions: const [],
                leading: null,
                automaticallyImplyLeading: false,
              ),
              // content
              SliverList(
                delegate: SliverChildListDelegate(
                  children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget content({required List<Widget> children}) {
    return Column(
      children: children,
    );
  }

  List<Widget> header({
    required Function onMenuTap,
  }) {
    return [
      Row(
        children: [
          OutlinedButton.icon(
            onPressed: () {
              onMenuTap();
            },
            icon: const Icon(Icons.menu),
            label: Text(
              AppLocalizations.of(context)!.menu,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Colors.black12,
              ),
              foregroundColor: Colors.black,
            ),
          ),
          const Spacer(),
          if (offline) const Icon(Icons.wifi_off),
        ],
      ),
      const SizedBox(
        height: 56,
      ),
      Row(
        children: [
          Text(
            AppLocalizations.of(context)!.welcomeTo,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            AppLocalizations.of(context)!.wallmall,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      Text(
        AppLocalizations.of(context)!.yourWallpaperApp,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  Widget news({required List<WallpaperModel> wallpapers}) {
    // horizontal list view
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // gap
          const SizedBox(
            width: 20,
          ),
          // wallpapers
          ...wallpapers.map((wallpaper) {
            return Container(
              height: 160,
              width: 120,
              margin: const EdgeInsets.only(
                right: 10,
              ),
              child: WallpaperWidget(
                wallpaper: wallpaper,
              ),
            );
          }).toList(),
          // gap
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget categories({required List<CategoryModel> categories}) {
    // scrollbar row
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // gap
            const SizedBox(
              width: 20,
            ),
            // categories
            ...categories.map((category) {
              return CategoryWidget(
                category: category,
              );
            }).toList(),
            // gap
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget colors({required List<ColorModel> colors}) {
    // scrollbar row
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // gap
            const SizedBox(
              width: 20,
            ),
            // colors
            ...colors.map((color) {
              return ColorWidget(
                color: color,
              );
            }).toList(),
            // gap
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget title({required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      margin: const EdgeInsets.only(
        top: 20,
        bottom: 10,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
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

  Widget loadingrid() {
    // grid view of loading
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
      itemCount: loadingWidgets.length,
      itemBuilder: (_, index) {
        return loadingWidgets[index];
      },
    );
  }

  Widget drawer() {
    return const Drawer(
      child: DrawerWieget(),
    );
  }
}
