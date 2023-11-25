import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallmall/api/api.dart';
import 'package:wallmall/core/provider.dart';
import 'package:wallmall/models/category.dart';
import 'package:wallmall/widgets/category.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  List<CategoryModel> categories = [];
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

      var result = await api.categories(page: page);

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
        categories.addAll(result);
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
                  categories: categories,
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
    var provider = Provider.of<ShareProvider>(context);

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
              alignment: provider.locale == "en"
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context)!.categories,
                    style: const TextStyle(
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
    List<CategoryModel> categories = const [],
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
        childAspectRatio: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (_, index) {
        return SizedBox(
          height: 56,
          child: CategoryWidget(
            category: categories[index],
          ),
        );
      },
    );
  }
}
