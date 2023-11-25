import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerWieget extends StatefulWidget {
  const DrawerWieget({super.key});

  @override
  State<DrawerWieget> createState() => _DrawerWiegetState();
}

class _DrawerWiegetState extends State<DrawerWieget> {
  String version = "";

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // header
        Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                AppLocalizations.of(context)!.wallmall,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // privacy
        ListTile(
          leading: const Icon(Icons.security),
          title: Text(
            AppLocalizations.of(context)!.privacy,
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/_/page',
              arguments: {
                "key": "privacy",
                "title": AppLocalizations.of(context)!.privacy,
              },
            );
          },
        ),
        // favorites
        ListTile(
          leading: const Icon(Icons.favorite),
          title: Text(
            AppLocalizations.of(context)!.myFavorites,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/_/favorites');
          },
        ),
        // divider
        const Divider(
          color: Colors.transparent,
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.categories,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/_/categories');
          },
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.colors,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/_/colors');
          },
        ),
        // divider
        const Divider(
          color: Colors.transparent,
        ),
        // version 0.0.1
        ListTile(
          dense: true,
          title: Text(
            AppLocalizations.of(context)!.version(version),
          ),
        ),
      ],
    );
  }
}
