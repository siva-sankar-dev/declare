import 'package:flutter/material.dart';

class ColorModel {
  final Color color;
  final String colorName;

  const ColorModel({required this.color, required this.colorName});
  static const List<ColorModel> colors = [
    ColorModel(color: Colors.red, colorName: "Red"),
    ColorModel(color: Colors.yellow, colorName: "Yellow"),
    ColorModel(color: Colors.blue, colorName: "Blue"),
    ColorModel(color: Colors.green, colorName: "Green"),
    ColorModel(color: Colors.purple, colorName: "Purple"),
  ];
}
