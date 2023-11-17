import 'package:flutter/material.dart';
import 'package:wallmall/models/category.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryWidget extends StatefulWidget {
  final CategoryModel category;

  const CategoryWidget({super.key, required this.category});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          "/_/search/category",
          arguments: widget.category,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        height: 56,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              widget.category.image,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            widget.category.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
