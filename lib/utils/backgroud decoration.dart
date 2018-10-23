import 'package:flutter/material.dart';
import 'colors.dart';

BoxDecoration backgroundDecoration() => BoxDecoration(
  gradient: LinearGradient(
      colors: [Color(0xFF0000AA),Color(0xFFED217C)],
      begin: const Alignment(0.0, -1.0),
      end: const Alignment(0.0, 0.5),
      tileMode: TileMode.clamp
  )
);