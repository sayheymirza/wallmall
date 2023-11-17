import 'package:flutter/material.dart';
import 'package:wallmall/api/api.dart';
import 'package:wallmall/models/color.dart';
import 'package:wallmall/widgets/color.dart';

class ColorsView extends StatefulWidget {
  const ColorsView({super.key});

  @override
  State<ColorsView> createState() => _ColorsViewState();
}

class _ColorsViewState extends State<ColorsView> {
  List<ColorModel> colors = [];
  int page = 1;
  bool loading = false;
  bool loadingMore = true;

  @override
  void initState() {
    super.initState();

    fetchCategories();
  }

  void fetchCategories() async {
    if (loadingMore == false) {
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      var result = await api.colors(page: page);

      setState(() {
        loading = false;
      });

      if (result.isEmpty) {
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
        colors.addAll(result);
      });
    } catch (e) {
      print(e);
    }
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
                grid(
                  colors: colors,
                ),
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
      collapsedHeight: 140,
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Colors",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
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
    List<ColorModel> colors = const [],
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
        crossAxisCount: 4,
        childAspectRatio: 1.4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: colors.length,
      itemBuilder: (_, index) {
        return SizedBox(
          height: 56,
          child: ColorWidget(
            color: colors[index],
          ),
        );
      },
    );
  }
}
