import 'package:flutter/material.dart';

class AvatarModel {
  final String name;
  final String gender;
  final Color skinTone;
  final String hairStyle;
  final bool glasses;
  final String outfit;
  final Color accentColor;

  AvatarModel({
    required this.name,
    required this.gender,
    required this.skinTone,
    required this.hairStyle,
    required this.glasses,
    required this.outfit,
    required this.accentColor,
  });
}
