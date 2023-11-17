import 'package:flutter/material.dart';

class DrawerWieget extends StatefulWidget {
  const DrawerWieget({super.key});

  @override
  State<DrawerWieget> createState() => _DrawerWiegetState();
}

class _DrawerWiegetState extends State<DrawerWieget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // header
        Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "WallMall",
                style: TextStyle(
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
          title: const Text("Privacy"),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/_/page',
              arguments: {
                "key": "privacy",
                "title": "Privacy",
              },
            );
          },
        ),
        // favorites
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text("My favorites"),
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
          title: const Text("Categories"),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/_/categories');
          },
        ),
        ListTile(
          title: const Text("Colors"),
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
        const ListTile(
          dense: true,
          title: Text("Version 0.0.1"),
        ),
      ],
    );
  }
}
