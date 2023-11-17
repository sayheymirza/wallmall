import 'package:flutter/material.dart';
import 'package:wallmall/core/hex.dart';
import 'package:wallmall/models/color.dart';

class ColorWidget extends StatefulWidget {
  final ColorModel color;

  const ColorWidget({super.key, required this.color});

  @override
  State<ColorWidget> createState() => _ColorWidgetState();
}

class _ColorWidgetState extends State<ColorWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          "/_/search/color",
          arguments: widget.color,
        );
      },
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: HexColor(widget.color.value),
        ),
      ),
    );
  }
}
