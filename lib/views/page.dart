import 'package:flutter/material.dart';
import 'package:wallmall/api/api.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:wallmall/core/connectivity.dart';
import 'package:wallmall/core/database.dart';

class PageView extends StatefulWidget {
  const PageView({super.key});

  @override
  State<PageView> createState() => _PageViewState();
}

class _PageViewState extends State<PageView> {
  String content = "";
  String title = "";

  @override
  void initState() {
    super.initState();

    // wait for the widget to be rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var args = ModalRoute.of(context)!.settings.arguments as dynamic;

      // set title
      setState(() {
        title = args["title"];
      });

      // fetch page
      fetchPage(args["key"]);
    });
  }

  void fetchPage(String key) async {
    if (await connectivity.connected) {
      // fetch page
      try {
        var content = await api.page(key: key);

        if (content == null) {
          // ignore: use_build_context_synchronously
          return Navigator.pop(context);
        }

        setState(() {
          this.content = content;
        });

        database.setPage(key, content);
      } catch (e) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } else {
      database.getPage(key).then((value) {
        setState(() {
          content = value ?? "";
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: MarkdownBody(
            data: content,
          ),
        ),
      ),
    );
  }
}
