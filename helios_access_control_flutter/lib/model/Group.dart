import 'package:flutter/material.dart';

class Group {
  String label;
  String id;

  Group({
    @required this.label,
    this.id,
  });

  String get uniqueId => "${this.label}-${this.id}";
}
