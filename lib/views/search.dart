import 'package:flutter/material.dart';
import 'package:wallmall/api/api.dart';
import 'package:wallmall/core/ad.dart';
import 'package:wallmall/models/wallpaper.dart';
import 'package:wallmall/widgets/ad.dart';
import 'package:wallmall/widgets/wallpaper.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<Widget> widgets = [];
  String q = "";
  int page = 1;
  bool loading = false;
  bool loadingMore = true;
  int count = 0;

  // text field focus node
  final FocusNode textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    ad.init();

    // focus on text field when screen loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(textFieldFocusNode);
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
        q: q,
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
      } else {
        setState(() {
          page += 1;
        });
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
      body: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (!loading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchWallpapers();
          }

          return true;
        },
        child: CustomScrollView(
          // on scroll to bottom load more
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              primary: false,
              elevation: 0,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              // app bar content
              flexibleSpace: search(),
              // height of app bar
              toolbarHeight: 120,
              actions: [],
              leading: null,
              automaticallyImplyLeading: false,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                widgets,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget search() {
    return Container(
      height: 56,
      padding: const EdgeInsets.only(
        left: 4,
        right: 20,
      ),
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // back button
          const BackButton(),
          // gap 12
          const SizedBox(width: 12),
          // search text
          Expanded(
            child: TextField(
              focusNode: textFieldFocusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.searchWallpaper,
                hintStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  q = value;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  q = value;
                  widgets = [];
                  page = 1;
                  loadingMore = true;

                  fetchWallpapers();
                });
              },
            ),
          ),

          // search icon
          const Icon(Icons.search),
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
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
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
