import 'package:flutter/material.dart';

class TypeItem {
  final String label;
  final IconData? icons;
  bool selected;

  TypeItem({
    required this.label,
    this.icons,
    this.selected = false,
  });
}
